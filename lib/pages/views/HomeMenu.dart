import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/helpers/getMonth.dart';
import 'package:proyecto_sgca_ebu/models/Admin.dart';


class HomeMenuPage extends StatelessWidget {

  final fecha = {
    'dia': (DateTime.now().day) < 10 ? '0${(DateTime.now().day)}' : (DateTime.now().day),
    'mes': (DateTime.now().month),
    'año': DateTime.now().year,
  };

  final Future<Admin?> yearEscolar = controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false);
  final Future<int> cantidadDocentes = controladorUsuario.contarDocentes();
  final Future<Map<String,int>> cantidadEstudiantes = controladorMatriculaEstudiante.contarEstudiantesEnGrados();

  final simpleTextStyle = TextStyle(fontSize:18);

  final detailTextStyle = TextStyle(fontSize:18,fontWeight:FontWeight.bold);

  Column estudianteNumero (String grado, int numero) => Column(children: [
    Text(grado,style:simpleTextStyle),
    Text(numero.toString(),style:detailTextStyle)
  ]);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(      
      child: Column(children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            SimplifiedContainer(
              width:235,
              height: 150,
              child:FutureBuilder(
                future: yearEscolar,
                builder: (BuildContext context, AsyncSnapshot data) {
                  if(data.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(data.data == null){
                    return Center(child:Text('NO HAY AÑO ESCOLAR INSCRITO!'));
                  }
                  else{
                    return Row(            
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [
                      Icon(Icons.face,size:48),
                      Padding(padding:EdgeInsets.all(5)),
                      Column(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                        Text('${fecha["dia"]}/${(fecha['mes']! as int) < 10 ? '0${(fecha['mes'])}' : (fecha['mes'])}/${fecha["año"]}',style:simpleTextStyle),
                        Row(children:[
                          Text('Mes: ',style:simpleTextStyle),
                          Text(monthNumIntoString(fecha['mes']! as int),style:detailTextStyle)
                        ]),
                        Center(child:Text('Año escolar:',style:simpleTextStyle)),
                        Center(child:Text('${data.data.valor.split('-')[0]} - ${data.data.valor.split('-')[1]}',style:detailTextStyle))
                      ])
                    ]);
                  }
                },
              )
            ),
            
            SimplifiedContainer(
              width:235,
              height: 150,
              child: FutureBuilder(
                future: cantidadDocentes,
                builder: (BuildContext context, AsyncSnapshot data) {
                  if(data.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(data.data == null || data.data == 0){
                    return Center(child:Text('NO HAY DOCENTES INSCRITOS!'));
                  }
                  else{
                    return Row(children: [
                      Icon(Icons.assignment_ind,size:48),
                      Padding(padding:EdgeInsets.all(5)),
                      Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                        Center(child:Text('Docentes inscritos:',style:simpleTextStyle)),
                        Center(child:Text(data.data.toString(),style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)))
                      ])
                    ]);
                  }
                },
              ),              
            )
          ]),
          Padding(padding:EdgeInsets.symmetric(vertical:15)),
          SimplifiedContainer(
            child:FutureBuilder(
              future: cantidadEstudiantes,
              builder: (BuildContext context, AsyncSnapshot data) {
                if(data.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else{
                  return Row(children: [
                    Icon(Icons.face,size:48),
                    Padding(padding:EdgeInsets.symmetric(horizontal:15)),
                    Expanded(
                      child: Column(children:[
                        Center(child:Text('Estudiantes por grado:',style:simpleTextStyle)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[
                          estudianteNumero('1ero',data.data['1']),
                          estudianteNumero('2do',data.data['2']),
                          estudianteNumero('3ero',data.data['3']),
                          estudianteNumero('4to',data.data['4']),
                          estudianteNumero('5to',data.data['5']),
                          estudianteNumero('6to',data.data['6']),
                          Padding(padding:EdgeInsets.symmetric(horizontal:20)),
                          estudianteNumero('TOTAL',data.data['TOTAL'])
                        ])
                      ]),
                    )
                  ]);
                }
              },
            ),            
          )
        ]
      )
    );
  }
}