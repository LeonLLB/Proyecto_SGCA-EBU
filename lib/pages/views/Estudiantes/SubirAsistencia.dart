import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/MesPicker.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/controllers/Asistencia.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Asistencia.dart';

class SubirAsistenciaEstudiante extends StatefulWidget {

  @override
  State<SubirAsistenciaEstudiante> createState() => _SubirAsistenciaEstudianteState();
}

class _SubirAsistenciaEstudianteState extends State<SubirAsistenciaEstudiante> {

  Ambiente? ambiente;

  int? mes;
  
  List<Map<String,Object?>>? matriculaSeleccionada;

  List<List<Asistencia?>> listaAsistenciasSeccion = []; 

  List<int> diasDelMesNoHabiles = [];
  TextEditingController controllerDiasNoHabiles = TextEditingController();

  Future<List<Map<String,Object?>>?> dualChange () async {
    diasDelMesNoHabiles = [];    
    if(controllerDiasNoHabiles.text != ''){
      diasDelMesNoHabiles = controllerDiasNoHabiles.text.split(',').map((diaNoHabil)=>int.parse(diaNoHabil)).toList();
    }

    if(matriculaSeleccionada != null && mes != null){
      if(diasDelMesNoHabiles.length > 0){
        controladorAsistencia.eliminarAsistenciasSA(mes!, diasDelMesNoHabiles);
      }
      listaAsistenciasSeccion = [];   

      for(var i = 0; i < matriculaSeleccionada!.length;i++){
        final estudiante = matriculaSeleccionada![i];
        List<Asistencia?> tmp = [];
        for (var j = 1; j <= 31; j++) {
          int skipBegginingDays = 0;

          final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');

          final fechaActual = DateTime((mes! >= 6) ? (int.parse(yearEscolar!.valor.split('-')[0])) : (int.parse(yearEscolar!.valor.split('-')[1])),mes!,j);
          
          if(fechaActual.month != mes){
            break;
          }

          final diaSemana = DateFormat.E('es_ES').format(fechaActual);

          if(diaSemana == 'sáb.' || diaSemana == 'dom.'){
            continue;
          }
          if(j == 1){
            switch(diaSemana){
              case 'mar.':
                skipBegginingDays = 1;
                break;
              case 'mié.':
                skipBegginingDays = 2;
                break;
              case 'jue.':
                skipBegginingDays = 3;
                break;
              case 'vie.':
                skipBegginingDays = 4;
                break;
              default:
                skipBegginingDays = 0;
                break;
            }
          }
            controladorAsistencia.buscarAsistencia(mes!, estudiante['estudiante.id']! as int, j)
            .then((asistenciaVieja){
              if(asistenciaVieja != null){
                if (diasDelMesNoHabiles.contains(j)) {
                  if(j == 1) tmp.addAll([null,null]);
                  else tmp.add(null);
                }else{
                  tmp.add(asistenciaVieja);
                }
              }
              else{
                //SE INSERTA UNA VACIA
                if(diasDelMesNoHabiles.contains(j)){
                  if(j == 1) tmp.addAll([null,null]);
                  else tmp.add(null);
                }
                else if(skipBegginingDays > 0){
                  List skip = List.filled(skipBegginingDays+1, null);
                  tmp.addAll([
                    ...skip,
                    Asistencia(
                      estudianteID: estudiante['estudiante.id'] as int,
                      asistio: false,
                      dia: j,
                      mes: mes!
                    )
                  ]);
                }
                else{
                  tmp.add(Asistencia(
                    estudianteID: estudiante['estudiante.id'] as int,
                    asistio: false,
                    dia: j,
                    mes: mes!
                  ));
                }
              }
            });
          }
          listaAsistenciasSeccion.add(tmp);
          tmp=[];
        }        
        return matriculaSeleccionada;
      }
      return null;
    }

  void subirAsistencia(BuildContext context){
    List<int> resultados = [];
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message: 'Subiendo asistencias',
      onVisible:()async{
        for (var asistencias in listaAsistenciasSeccion){
          try {
            final results = await controladorAsistencia.registrarMes(asistencias.where((asistencia) => asistencia != null).toList() as List<Asistencia>);
            resultados.addAll(results);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al subir una asistencia'));  
          }
        }
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if(resultados.length > 0){
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se han subido o actualizado varias asistencias'));  
        }
      }
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: SingleChildScrollView(
        child:Column(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              AmbientePicker(onChange: (ambienteSeleccionado)async{
                ambiente = ambienteSeleccionado;
                matriculaSeleccionada = await controladorMatriculaEstudiante.getMatricula(ambiente!.id);
                                
                setState((){});
              }),
              MesPicker(onChange: (mesSeleccionado){
                mes = mesSeleccionado!;
                
                setState((){});
              })
            ],
          ),
          Padding(padding:EdgeInsets.symmetric(vertical: 5)),
          Row(
            children: [
              SimplifiedTextFormField(
                controlador: controllerDiasNoHabiles,
                labelText: 'Dias no habiles',
                validators: TextFormFieldValidators(),
                helperText:'Los dias deben de ser separados por comas (,) sin espacios (1,5,6,7,8,24,25,23)'
              )
            ],
          ),
          Padding(padding:EdgeInsets.symmetric(vertical: 5)),
          ElevatedButton.icon(
            onPressed: (){setState((){});},
            icon:Icon(Icons.refresh),
            label:Text('Actualizar')
          ),
          //BOTON PARA ACTUALIZAR
          Padding(padding:EdgeInsets.symmetric(vertical: 5)),
          FutureBuilder(
            future: dualChange(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if(data.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              else if(data.data == null){
                return Center(child:Text('No hubo resultados, esto puede deberse a que no haya ambientes inscritos, no haya una matricula de docentes para ese ambiente, o no haya estudiantes en el aula solicitada'));
              }
              else{
                return Column(children: [
                  SimplifiedContainer(child: Column(children: [
                    Text(data.data[0]['docente.nombres'] + ' ' + data.data[0]['docente.apellidos'] ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                        Text(data.data[0]['añoEscolar']),
                        Row(children: [
                          Text(data.data[0]['grado'].toString()+'° '),
                          Text('\"'+data.data[0]['seccion']+'\"'),
                        ])
                      ]
                    ),
                    Text('Total de estudiantes: ${data.data[0]['CantidadEstudiantes']}'),
                    Text('Turno: ${(data.data[0]['turno'] == 'M') ? 'Mañana' : 'Tarde'}'),
                    
                  ])),
                  Padding(padding:EdgeInsets.symmetric(vertical: 5)),                  
                  Table(
                    //border: TableBorder.all(),
                    border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                    children:[
                      TableRow(
                        children:[
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('Nombres')),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('Apellidos')),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child:Column(
                                children: [
                                  Text('Dias del mes'),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:[
                                      Text('L'),
                                      Text('M'),
                                      Text('M'),
                                      Text('J'),
                                      Text('V'),
                                    ]
                                  )
                                ],
                              )),
                            )
                          ),
                        ]
                      ),
                      ...data.data.asMap().entries.map((estudiante)=>TableRow(
                        children:[
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text(estudiante.value['estudiante.nombres'])),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text(estudiante.value['estudiante.apellidos'])),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              //PRIMERA SEMANA
                              child: _MesCheckboxList(
                                onChange: (val){
                                  listaAsistenciasSeccion[estudiante.key] = val;                                  
                                },
                                asistencia: listaAsistenciasSeccion[estudiante.key]
                              )
                            )
                          ),
                        ]
                      )).toList()
                    ]
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical: 5)), 
                  ElevatedButton(
                    onPressed: (){
                      subirAsistencia(context);
                    },
                    child: Text('Subir asistencia')
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical: 5))
                ]);
              }
            },
          ),
        ])
      )
    );
  }

}

class _MesCheckboxList extends StatefulWidget {


  final void Function(List<Asistencia?>) onChange;
  final List<Asistencia?> asistencia;

  _MesCheckboxList({required this.onChange,required this.asistencia});

  @override
  __MesCheckboxListState createState() => __MesCheckboxListState(onChange:onChange,asistencias:asistencia);
}

class __MesCheckboxListState extends State<_MesCheckboxList> {

  final void Function(List<Asistencia?>) onChange;

  List<Asistencia?> asistencias;

  __MesCheckboxListState({
    required this.onChange,
    required this.asistencias
  });

  @override
  Widget build(BuildContext context) { 
    

    return Wrap(
      children:asistencias.map((asistencia){
        if(asistencia == null){
          return SizedBox(width:30,height:25);
        }
        return Row(
          mainAxisSize:MainAxisSize.min,
          children: [
            Text(asistencia.dia.toString(),style:TextStyle(fontSize:(asistencia.dia >= 10) ? 10: 12)),
            Checkbox(
              value: asistencia.asistio, onChanged: (asistio){
                asistencias[asistencias.indexOf(asistencia)]!.asistio=asistio!;
                onChange(asistencias);
                setState((){});
              }
            ),
          ],
        );
      }).toList()
    );
  }
}