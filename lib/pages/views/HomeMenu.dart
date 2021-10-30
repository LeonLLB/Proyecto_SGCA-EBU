import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/helpers/getMonth.dart';


class HomeMenuPage extends StatelessWidget {

  final fecha = {
    'dia':(DateTime.now().day) < 10 ? '0${(DateTime.now().day)}' : (DateTime.now().day),
    'mes':(DateTime.now().month) < 10 ? '0${(DateTime.now().month)}' : (DateTime.now().month),
    'año':DateTime.now().year,
  };

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
            SimplifiedContainer(width:225, height: 150,child: Row(            
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
              Icon(Icons.face,size:48),
              Padding(padding:EdgeInsets.all(5)),
              Column(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                Text('${fecha["dia"]}/${fecha["mes"]}/${fecha["año"]}',style:simpleTextStyle),
                Row(children:[
                  Text('Mes: ',style:simpleTextStyle),
                  Text(monthNumIntoString(fecha['mes']! as int),style:detailTextStyle)
                ]),
                Center(child:Text('Año escolar:',style:simpleTextStyle)),
                Center(child:Text('${fecha["año"]} - ${DateTime.now().year + 1}',style:detailTextStyle))
              ])
            ])),
            SimplifiedContainer(width:225, height: 150,child: Row(children: [
              Icon(Icons.assignment_ind,size:48),
              Padding(padding:EdgeInsets.all(5)),
              Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                Center(child:Text('Docentes activos:',style:simpleTextStyle)),
                Center(child:Text('16',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)))
              ])
            ]))
          ]),
          Padding(padding:EdgeInsets.symmetric(vertical:15)),
          SimplifiedContainer(child: Row(children: [
            Icon(Icons.face,size:48),
            Padding(padding:EdgeInsets.symmetric(horizontal:15)),
            Expanded(
              child: Column(children:[
                Center(child:Text('Estudiantes por grado:',style:simpleTextStyle)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[
                  estudianteNumero('1ero',34),
                  estudianteNumero('2do',24),
                  estudianteNumero('3ero',47),
                  estudianteNumero('4to',78),
                  estudianteNumero('5to',46),
                  estudianteNumero('6to',26),
                  Padding(padding:EdgeInsets.symmetric(horizontal:20)),
                  estudianteNumero('TOTAL',255)
                ])
              ]),
            )
          ]))
        ]
      )
    );
  }
}