import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';

class AdminVerGrado extends StatelessWidget {

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
      future: controladorAmbientes.obtenerGrados(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot data) {
        if(data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(data.data == null){
          return Center(child:Text('No hay ambientes disponibles'));
        }
        else{
          return Expanded(
            child: ListView.separated(
              itemCount:data.data.length,
              itemBuilder: (_,i)=>ListTile(
                
                leading: CircleAvatar(
                  backgroundColor: colorList[data.data[i].grado-1],
                  child: Text(data.data[i].grado.toString())
                ),
                title: Text(data.data[i].seccion + ': ' + "${(data.data[i].turno == 'M') ? 'Mañana' : 'Tarde'}")
              ),
              separatorBuilder: (_,i)=> Divider(),
            ),
          );
        }
      },
    );
  }
}