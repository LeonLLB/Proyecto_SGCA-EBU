import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/MesPicker.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
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
  
  Future<List<Map<String,Object?>>?> matriculaSeleccionada = controladorMatriculaEstudiante.getMatricula(null);

  List<List<AsistenciaTemporal>> listaAsistenciasSeccion = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child:Column(children: [
          AmbientePicker(onChange: (ambienteSeleccionado)async{
            ambiente = ambienteSeleccionado;
            matriculaSeleccionada = controladorMatriculaEstudiante.getMatricula(ambiente!.id);
            if (await matriculaSeleccionada != null) {

              listaAsistenciasSeccion = [];

              await matriculaSeleccionada.then((matricula){
                for(var estudiante in matricula!){
                  //TODO: ESTO DEBE SER INFORMACION DE LOS REGISTROS DE ASISTENCIA DIRECTAMENTE
                  List<AsistenciaTemporal> tmp = []; 
                  for (var i = 1; i <= 4; i++) {
                    tmp.add(AsistenciaTemporal(
                      estudianteID:estudiante['id'] as int,
                      lunes: false,
                      martes: false,
                      miercoles: false,
                      jueves: false,
                      viernes: false,
                      numeroSemana:i
                    ));
                  }
                  listaAsistenciasSeccion.add(tmp);
                }
              });
            }
            setState((){});
          }),
          Padding(padding:EdgeInsets.symmetric(vertical: 5)),
          FutureBuilder(
            future: matriculaSeleccionada,
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
                    MesPicker(onChange: (mesSeleccionado){
                      mes = mesSeleccionado!;
                      //TODO: BUSCAR ASISTENCIAS DEL MES Y DEL MISMO AÑO ESCOLAR
                      setState((){});
                    })
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
                              child: Center(child:Text('Primera semana')),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(4),
                              child: Center(child: Text('Segunda semana')),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('Tercera Semana')),
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('Cuarta Semana')),
                            )
                          )
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
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                //PRIMERA SEMANA
                                CheckboxListTile(
                                  title:Text('L'),
                                  value:listaAsistenciasSeccion[estudiante.key][0].lunes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][0].lunes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][0].martes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][0].martes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][0].miercoles,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][0].miercoles = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('J'),
                                  value:listaAsistenciasSeccion[estudiante.key][0].jueves,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][0].jueves = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('V'),
                                  value:listaAsistenciasSeccion[estudiante.key][0].viernes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][0].viernes = val!;
                                    setState((){});
                                  }  
                                ),
                              ],)
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                //SEGUNDA SEMANDA
                                CheckboxListTile(
                                  title:Text('L'),
                                  value:listaAsistenciasSeccion[estudiante.key][1].lunes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][1].lunes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][1].martes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][1].martes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][1].miercoles,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][1].miercoles = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('J'),
                                  value:listaAsistenciasSeccion[estudiante.key][1].jueves,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][1].jueves = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('V'),
                                  value:listaAsistenciasSeccion[estudiante.key][1].viernes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][1].viernes = val!;
                                    setState((){});
                                  }  
                                ),
                              ],)
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                //TERCERA SEMANA
                                CheckboxListTile(
                                  title:Text('L'),
                                  value:listaAsistenciasSeccion[estudiante.key][2].lunes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][2].lunes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][2].martes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][2].martes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][2].miercoles,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][2].miercoles = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('J'),
                                  value:listaAsistenciasSeccion[estudiante.key][2].jueves,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][2].jueves = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('V'),
                                  value:listaAsistenciasSeccion[estudiante.key][2].viernes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][2].viernes = val!;
                                    setState((){});
                                  }  
                                ),
                              ],)
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                //CUARTA SEMANA                                
                                CheckboxListTile(
                                  title:Text('L'),
                                  value:listaAsistenciasSeccion[estudiante.key][3].lunes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][3].lunes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][3].martes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][3].martes = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('M'),
                                  value:listaAsistenciasSeccion[estudiante.key][3].miercoles,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][3].miercoles = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('J'),
                                  value:listaAsistenciasSeccion[estudiante.key][3].jueves,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][3].jueves = val!;
                                    setState((){});
                                  }  
                                ),
                                CheckboxListTile(
                                  title:Text('V'),
                                  value:listaAsistenciasSeccion[estudiante.key][3].viernes,
                                  onChanged:(val){
                                    listaAsistenciasSeccion[estudiante.key][3].viernes = val!;
                                    setState((){});
                                  }  
                                ),
                              ],)
                            )
                          )
                        ]
                      )).toList()
                    ]
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical: 5)), 
                  ElevatedButton(
                    onPressed: (){},
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