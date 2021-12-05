import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/SessionProvider.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaDocente.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/services/PDF.dart';

class MatriculaEstudiante extends StatefulWidget {

  @override
  State<MatriculaEstudiante> createState() => _MatriculaEstudianteState();
}

class _MatriculaEstudianteState extends State<MatriculaEstudiante> {

  Ambiente? ambiente;
  
  Future<List<Map<String,Object?>>?> matriculaSeleccionada = controladorMatriculaEstudiante.getMatricula(null);

  Future<void> identifyCase(BuildContext context)async{
    final session = Provider.of<SessionProvider>(context,listen:false).usuario;
    if(session.rol == 'A') return;
    final ambienteDocente = await controladorMatriculaDocente.obtenerAmbienteAsignado(session.id);

    ambiente = ambienteDocente;
    matriculaSeleccionada = controladorMatriculaEstudiante.getMatricula(ambienteDocente!.id);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: identifyCase(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final session = Provider.of<SessionProvider>(context,listen:false).usuario;
        return Expanded(
          child: SingleChildScrollView(
            child:Column(children: [
              (session.rol == 'A')?AmbientePicker(onChange: (ambienteSeleccionado){
                ambiente = ambienteSeleccionado;
                matriculaSeleccionada = controladorMatriculaEstudiante.getMatricula(ambiente!.id);
                
                setState((){});
              }):SizedBox(),
              Padding(padding:EdgeInsets.symmetric(vertical: 5)),
              FutureBuilder(
                future: matriculaSeleccionada,
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
                        Row(children: [
                          Text('Matricula escolar de '),
                          Text(data.data[0]['grado'].toString()+'° ' + '\"'+data.data[0]['seccion']+'\"',style:TextStyle(fontWeight: FontWeight.bold)),
                        ])
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
                                  child: Center(child: Text('Cedula escolar')),
                                )
                              ),
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text('Fecha Nacimiento')),
                                )
                              ),
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text('Edad')),
                                )
                              )
                            ]
                          ),
                          ...data.data.map((estudiante)=>TableRow(
                            children:[
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text(estudiante['estudiante.nombres'])),
                                )
                              ),
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text(estudiante['estudiante.apellidos'])),
                                )
                              ),
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text(estudiante['cedula'].toString())),
                                )
                              ),
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text(estudiante['fecha_nacimiento'])),
                                )
                              ),
                              TableCell(
                                child:  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(child: Text(calcularEdad(estudiante['fecha_nacimiento']).toString()  + ' años')),
                                )
                              )
                            ]
                          )).toList()
                        ]
                      ),
                      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
                      ElevatedButton(onPressed: (){
                        if (ambiente != null) {
                          ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                            message:'Generando documento de la matrícula de los estudiantes...',
                            onVisible: () async {
                              final bool seGenero = await generarDocumentoMatriculaEstudiantes(ambiente!.id!);
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              if(seGenero){
                                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente el documento, revise el directorio de descargas'));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar el documento'));
                              }
                            }
                            )
                          );
                        }
                      }, child: Text('Generar PDF')),
                      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
                    ]);
                  }
                },
              ),
            ])
          )
        );
      },
    ); 
  }
}