import 'package:flutter/material.dart';
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

  Future<List<Map<String,Object?>>?> dualChange () async {
    if(matriculaSeleccionada != null && mes != null){
      listaAsistenciasSeccion = [];
      
      for(var i = 0; i < matriculaSeleccionada!.length;i++){
        final estudiante = matriculaSeleccionada![i];
        List<Asistencia> tmp = [];

        for (var j = 1; j <= 4; j++) {
          final condition = await controladorAsistencia.existeAsistencia(mes!, estudiante['estudiante.id']! as int, j);
          if(condition){
            //SE BUSCA LA QUE EXISTE
            final asistenciaVieja = await controladorAsistencia.buscarAsistencia(mes!, estudiante['estudiante.id']! as int, j);
            tmp.add(asistenciaVieja!);
          }else{
            //SE INSERTA UNA VACIA
            tmp.add(Asistencia(
              estudianteID: estudiante['estudiante.id'] as int,
              lunes: false,
              martes: false,
              miercoles: false,
              jueves: false,
              viernes: false,
              numeroSemana: j,
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
                              //PRIMERA SEMANA
                              child: _SemanaCheckboxList(
                                onChange: (val){
                                  listaAsistenciasSeccion[estudiante.key][0] = val;                                  
                                },
                                asistencia: listaAsistenciasSeccion[estudiante.key][0]
                              )
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              //SEGUNDA SEMANA
                              child: _SemanaCheckboxList(
                                onChange: (val){
                                  listaAsistenciasSeccion[estudiante.key][1] = val;
                                },
                                asistencia: listaAsistenciasSeccion[estudiante.key][1]
                              )
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              //TERCERA SEMANA
                              child: _SemanaCheckboxList(
                                onChange: (val){
                                  listaAsistenciasSeccion[estudiante.key][2] = val;
                                },
                                asistencia: listaAsistenciasSeccion[estudiante.key][2]
                              )
                            )
                          ),
                          TableCell(
                            child:  Padding(
                              padding: EdgeInsets.all(5),
                              //CUARTA SEMANA
                              child: _SemanaCheckboxList(
                                onChange: (val){
                                  listaAsistenciasSeccion[estudiante.key][3] = val;
                                },
                                asistencia: listaAsistenciasSeccion[estudiante.key][3]
                              )
                            )
                          )
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

class _SemanaCheckboxList extends StatefulWidget {


  final void Function(Asistencia) onChange;
  final Asistencia asistencia;

  _SemanaCheckboxList({required this.onChange,required this.asistencia});

  @override
  __SemanaCheckboxListState createState() => __SemanaCheckboxListState(onChange:onChange,asistencia:asistencia);
}

class __SemanaCheckboxListState extends State<_SemanaCheckboxList> {

  final void Function(Asistencia) onChange;

  Asistencia asistencia;

  __SemanaCheckboxListState({
    required this.onChange,
    required this.asistencia
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,children: [
      CheckboxListTile(
        title:Text('L'),
        value:asistencia.lunes,
        onChanged:(val){
          asistencia.lunes = val!;
          setState((){onChange(asistencia);});
        }  
      ),
      CheckboxListTile(
        title:Text('M'),
        value:asistencia.martes,
        onChanged:(val){
          asistencia.martes = val!;
          setState((){onChange(asistencia);});
        }  
      ),
      CheckboxListTile(
        title:Text('M'),
        value:asistencia.miercoles,
        onChanged:(val){
          asistencia.miercoles = val!;
          setState((){onChange(asistencia);});
        }  
      ),
      CheckboxListTile(
        title:Text('J'),
        value:asistencia.jueves,
        onChanged:(val){
          asistencia.jueves = val!;
          setState((){onChange(asistencia);});
        }  
      ),
      CheckboxListTile(
        title:Text('V'),
        value:asistencia.viernes,
        onChanged:(val){
          asistencia.viernes = val!;
          setState((){onChange(asistencia);});
        }  
      ),
    ]
  );
  }
}