import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaDocente.dart';

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
    return FutureBuilder(
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
          return Expanded(
            child: ListView.separated(
              itemCount:data.data.length,
              itemBuilder: (_,i)=>ListTile(                
                leading: CircleAvatar(
                  backgroundColor: colorList[data.data[i]['grado']-1],
                  child: Text(data.data[i]['grado'].toString()+'° ')
                ),
                title: Column(children:[
                  Text('\"'+data.data[i]['seccion']+'\" ' + "${(data.data[i]['turno'] == 'M') ? 'Mañana' : 'Tarde'} "),
                  (data.data[i]['id'] == null) ? Row(mainAxisAlignment:MainAxisAlignment.center,children:[
                    Icon(Icons.warning,color:Colors.red),
                    Text('  No hay docente para esta aula',style:TextStyle(color:Colors.red))
                  ]) : Text('Docente: ' + data.data[i]['nombres'] + ' ' + data.data[i]['apellidos'] + ' '),
                  (data.data[i]['id'] == null) ? SizedBox() : Text('Estudiantes: ' + ((data.data[i]['CantidadEstudiantes'] == null) ? '0' : data.data[i]['CantidadEstudiantes'].toString() )) 

                ])
              ),
              separatorBuilder: (_,i)=> Divider(),
            ),
          );
        }
      }
    );
  }
}