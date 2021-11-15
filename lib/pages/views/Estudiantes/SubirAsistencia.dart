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

  List<Asistencia> listaAsistenciasSeccion = []; 

  List<int> diasDelMesNoHabiles = [];
  List<int> mementoDiasDelMesNoHabiles = [];
  List<int?> diasDelMesHabiles = [];

  TextEditingController controllerDiasNoHabiles = TextEditingController();


  Future<List<Map<String,Object?>>?> dualChange () async {
    diasDelMesNoHabiles = [];
    diasDelMesHabiles = [];   

    if(matriculaSeleccionada != null && mes != null){

        //PASO 1: SACAR LOS DIAS NO HABILES
      if(controllerDiasNoHabiles.text != ''){
        diasDelMesNoHabiles = controllerDiasNoHabiles.text.split(',').map((diaNoHabil)=>int.parse(diaNoHabil)).toList();
      }

      //PASO 2: SACAR LOS DIAS HABILES
      for(var i = 1; i <= 31; i++){
        final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');

        final fechaActual = DateTime((mes! >= 6) ? (int.parse(yearEscolar!.valor.split('-')[0])) : (int.parse(yearEscolar!.valor.split('-')[1])),mes!,i);
        
        if(fechaActual.month != mes!){
          break;
        }
        
        final diaSemana = DateFormat.E('es_ES').format(fechaActual);
        
        if(diasDelMesNoHabiles.contains(i) || (diaSemana == 'sáb.' || diaSemana == 'dom.')){
          if(diasDelMesNoHabiles.contains(i) && (diaSemana != 'sáb.' || diaSemana != 'dom.')){
            diasDelMesHabiles.add(null);
          }
          continue;
        }
        else{
          if(i == 1){
            switch(diaSemana){
              case 'mar.':
                diasDelMesHabiles.addAll([null,null,i]);
                break;
              case 'mié.':
                diasDelMesHabiles.addAll([null,null,null,i]);
                break;
              case 'jue.':
                diasDelMesHabiles.addAll([null,null,null,null,i]);
                break;
              case 'vie.':
                diasDelMesHabiles.addAll([null,null,null,null,null,i]);
                break;
              default:
                diasDelMesHabiles.add(i);
                break;
            }
          }else{
            diasDelMesHabiles.add(i);
          }
        }
      }
    
      listaAsistenciasSeccion = [];   
      //PASO 3: POR CADA ESTUDIANTE, DEBE TENER SU ASISTENCIA MENSUAL

      if(diasDelMesNoHabiles.length > 0 && diasDelMesNoHabiles != mementoDiasDelMesNoHabiles){
        controladorAsistencia.eliminarAsistencias(mes!,ambiente!.id!,diasDelMesNoHabiles);
        mementoDiasDelMesNoHabiles = diasDelMesNoHabiles;
      }

      final asistenciasViejas = await controladorAsistencia.buscarAsistencias(mes!,ambiente!.id!,true);

      if (asistenciasViejas != null) {
        for(var asistenciaVieja in asistenciasViejas){
          if(asistenciaVieja['id'] != null){
            //SE INSERTA UNA HECHA
            listaAsistenciasSeccion.add(Asistencia.fromMap(asistenciaVieja));
          }else{
            //SE INSERTA UNA VACIA
            listaAsistenciasSeccion.add(Asistencia(
              estudianteID: asistenciaVieja['estudianteID'] as int,
              asistencias:[],
              mes: mes!
            ));
          }
        }
      }
      return matriculaSeleccionada;
    }
    return null;
  }

  void subirAsistencia(BuildContext context){
    List<int> resultados = [];
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message: 'Subiendo asistencias...',
      onVisible:()async{
        try {
          final results = await controladorAsistencia.registrarMes(listaAsistenciasSeccion);
          resultados.addAll(results);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al subir una asistencia'));  
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
              else if(data.data == null || data.data[0]['docente.nombres'] == null){
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
                                diasHabiles:diasDelMesHabiles,
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


  final void Function(Asistencia) onChange;
  final Asistencia asistencia;
  final List<int?> diasHabiles;

  _MesCheckboxList({required this.diasHabiles,required this.onChange,required this.asistencia});

  @override
  __MesCheckboxListState createState() => __MesCheckboxListState(diasHabiles:diasHabiles,onChange:onChange,asistencias:asistencia);
}

class __MesCheckboxListState extends State<_MesCheckboxList> {

  final void Function(Asistencia) onChange;
  Asistencia asistencias;
  final List<int?> diasHabiles;

  __MesCheckboxListState({
    required this.onChange,
    required this.diasHabiles,
    required this.asistencias
  });

  @override
  Widget build(BuildContext context) {     

    return Wrap(
      children:diasHabiles.map((diaHabil){
        if(diaHabil == null){
          return SizedBox(width:35,height:25);
        }
        return Row(
          mainAxisSize:MainAxisSize.min,
          children: [
            Text(diaHabil.toString(),style:TextStyle(fontSize:(diaHabil >= 10) ? 10: 12)),
            Checkbox(
              value: asistencias.asistencias.contains(diaHabil),
              onChanged: (asistio){
                if(asistio!){
                  asistencias.asistencias.add(diaHabil);
                }else{
                  asistencias.asistencias.remove(diaHabil);
                }
                asistencias.asistencias.sort();
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