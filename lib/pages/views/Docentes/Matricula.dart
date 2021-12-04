import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaDocente.dart';
import 'package:proyecto_sgca_ebu/services/PDF.dart';

class MatriculaDocente extends StatelessWidget {

  final List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.cyan
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: controladorMatriculaDocente.obtenerMatriculaCompleta(),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot data) {
            if(data.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if(data.data == null){
              return Center(child:Text('No hay matriculas, o no hay ambientes para las matriculas'));
            }
            else{
              return Column(
                children: [
                  ElevatedButton(onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                      message:'Generando documento de la matrícula de los docentes...',
                      onVisible: () async {
                        final bool seGenero = await generarDocumentoMatriculaDocentes();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        if(seGenero){
                          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente el documento, revise el directorio de descargas'));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar el documento'));
                        }
                      }
                      )
                    );
                  },child:Text('Generar PDF')),
                  Padding(padding:EdgeInsets.symmetric(vertical: 5)),
                  Table(
                    border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                    children:[
                      TableRow(children:[
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Aula')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Turno')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Docente')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Estudiantes')),
                          )
                        ),
                      ]),
                      ...data.data.map((matricula)=>TableRow(children:[
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('${matricula['grado']}° "${matricula['seccion']}"',style:TextStyle(backgroundColor:colorList[matricula['grado']-1]))),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('${(matricula['turno']) == 'M' ? 'Mañana' : 'Tarde'}')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: (matricula['id'] == null)?
                              Wrap(
                                alignment:WrapAlignment.center,
                                children: [
                                  Icon(Icons.warning,color:Colors.red),
                                  Text('No hay docente para esta aula',style:TextStyle(color:Colors.red))
                                ]):
                              Text('${matricula['nombres']} ${matricula['apellidos']}')
                            ),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: (matricula['id'] == null)?
                              SizedBox():
                              Text('${matricula['CantidadEstudiantes']}')
                            ),
                          )
                        ),
                      ])).toList()
                    ]
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical: 5)),                  
                ],
              );
            }
          }
        ),
      ),
    );
  }
}