import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/MesPicker.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
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

  List<List<Asistencia>> listaAsistenciasSeccion = [];
  List<int> diasDelMes = [];

  Future<List<Map<String,Object?>>?> dualChange () async {

    if(matriculaSeleccionada != null && mes != null){
      listaAsistenciasSeccion = [];      
      diasDelMes = [];

      for(var i = 0; i < matriculaSeleccionada!.length;i++){
        final estudiante = matriculaSeleccionada![i];
        List<Asistencia> tmp = [];
        for (var j = 1; j <= 31; j++) {
          
          final fechaActual = DateTime((mes! >= 6) ? (DateTime.now().year) : (DateTime(DateTime.now().year+1).year),mes!,j);
          
          if(fechaActual.month != mes){
            break;
          }

          final diaSemana = DateFormat.E('es_ES').format(fechaActual);

          if(diaSemana == 'sáb.' || diaSemana == 'dom.'){
            continue;
          }
          else{
            if(i == 0){
              switch(diaSemana){
                case 'lun.':
                  diasDelMes.add(j);
                  break;
                case 'mar.':
                  if(diasDelMes.length == 0){
                    diasDelMes.addAll([0,j]);
                  }else{
                    diasDelMes.add(j);
                  }
                  break;
                case 'mié.':
                  if(diasDelMes.length == 0){
                    diasDelMes.addAll([0,0,j]);
                  }else{
                    diasDelMes.add(j);
                  }
                  break;
                case 'jue.':
                  if(diasDelMes.length == 0){
                    diasDelMes.addAll([0,0,0,j]);
                  }else{
                    diasDelMes.add(j);
                  }
                  break;
                case 'vie.':
                  if(diasDelMes.length == 0){
                    diasDelMes.addAll([0,0,0,0,j]);
                  }else{
                    diasDelMes.add(j);
                  }
                  break;
              }
            }            
          }

          final condition = await controladorAsistencia.existeAsistencia(mes!, estudiante['estudiante.id']! as int, j);
          if(condition){
            //SE BUSCA LA QUE EXISTE
            final asistenciaVieja = await controladorAsistencia.buscarAsistencia(mes!, estudiante['estudiante.id']! as int, j);
            tmp.add(asistenciaVieja!);
          }else{
            //SE INSERTA UNA VACIA
            tmp.add(Asistencia(
              estudianteID: estudiante['estudiante.id'] as int,
              asistio: false,
              dia: j,
              mes: mes!
            ));
          }
        }
        listaAsistenciasSeccion.add(tmp);
        tmp=[];
        
      }
      return matriculaSeleccionada;
    }
    return null;
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
                      for(var asistencias in listaAsistenciasSeccion){
                        for(var asistencia in asistencias){
                          print(asistencia.toJson());
                        }
                      }
                    },
                    child: Text('Subir asistencia')
                  )
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


  final void Function(List<Asistencia>) onChange;
  final List<Asistencia> asistencia;

  _MesCheckboxList({required this.onChange,required this.asistencia});

  @override
  __MesCheckboxListState createState() => __MesCheckboxListState(onChange:onChange,asistencia:asistencia);
}

class __MesCheckboxListState extends State<_MesCheckboxList> {

  final void Function(List<Asistencia>) onChange;

  List<Asistencia> asistencias;

  __MesCheckboxListState({
    required this.onChange,
    required this.asistencias
  });

  @override
  Widget build(BuildContext context) {
    List<Row> checkBoxRows = [];
    List<List<CheckboxListTile>> checkBoxTiles = [];

    for(var asistencia in asistencias){

      for (var i = 0; i < 5; i++) {
        if()
          checkBoxTiles[i].add(
            CheckboxListTile(
              value: asistencias[asistencias.indexWhere((element) => element == asistencia)].asistio,
              title:Text(asistencia.dia.toString()),
              onChanged: (val){
                asistencias[asistencias.indexWhere((element) => element == asistencia)].asistio = val!;
                setState((){
                  onChange(asistencias);
                });
              }
            )
          );
        }

    }

    for(var i = 0; i < 5; i++){

    }

    return Text('hi');
  }
}