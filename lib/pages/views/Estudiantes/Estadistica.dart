import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/controllers/Estadistica.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/MesPicker.dart';

class EstadisticaEstudiante extends StatefulWidget {

  @override
  State<EstadisticaEstudiante> createState() => _EstadisticaEstudianteState();
}
//WIDGET PRINCIPAL
class _EstadisticaEstudianteState extends State<EstadisticaEstudiante> {

  Ambiente? ambiente;

  int? mes;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(child:SingleChildScrollView(child:Column(children: [
      Row(
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: [
          AmbientePicker(onChange: (ambienteSeleccionado)async{
            ambiente = ambienteSeleccionado;

            setState((){});
          }),
          MesPicker(onChange: (mesSeleccionado){
            mes = mesSeleccionado!;
            
            setState((){});
          })
        ],
      ),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
      //ESTADISTICA DE LA MATRICULA
      Center(child:Text('Estadística de la matrícula escolar',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
      _EstadisticaMatricula(mes:mes,ambiente:ambiente),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
      //CLASIFICACION POR EDAD Y SEXO
      Center(child:Text('Clasificación por edad y sexo',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
      _ClasificacionEdadSexo(mes:mes,ambiente:ambiente),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
      //ESTADISTICA DE LA ASISTENCIA
      Center(child:Text('Estadística de la asistencia',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
      _EstadisticaAsistencia(mes:mes,ambiente:ambiente),
      Padding(padding:EdgeInsets.symmetric(vertical: 5)),
    ])));
  }
}
//ESTADISTICA DE LA MATRICULA
class _EstadisticaMatricula extends StatelessWidget {

  final Ambiente? ambiente;
  final int? mes;

  _EstadisticaMatricula({required this.ambiente, required this.mes});

  Future<dynamic> onLoad()async{
    if(ambiente == null || mes == null) return null; 
    final results = await controladorEstadistica.getMatricula(ambiente!.id,mes,false);
    
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot data) {
        if(data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(data.data == null){
          return Center(child:Text('No hubo resultados, esto puede ser porque no haya estudiantes en el aula solicitada'));
        }
        else{
          return Table(
            border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
            children:[
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Varones')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Hembras')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Total')),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Días habiles')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Dias Habiles']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Dias Habiles']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Dias Habiles']['V'].toString())),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Matrícula')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Matricula']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Matricula']['H'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Matricula']['T'].toString())),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('1° Día del mes')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['1° Dia']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['1° Dia']['H'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['1° Dia']['T'].toString())),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Egresos')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Egresos']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Egresos']['H'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Egresos']['T'].toString())),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Ingresos')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Ingresos']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Ingresos']['H'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Ingresos']['T'].toString())),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Matrícula final')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Matricula Final']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Matricula Final']['H'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Matricula Final']['T'].toString())),
                  )
                ),
              ]),
            ]
          );
        }
      },
    );
  }
}
//CLASIFICACION POR EDAD Y SEXO
class _ClasificacionEdadSexo extends StatelessWidget {

  final Ambiente? ambiente;
  final int? mes;

  _ClasificacionEdadSexo({required this.ambiente, required this.mes});

  Future<dynamic> onLoad()async{
    if(ambiente == null) return null; 
    final results = await controladorEstadistica.getClasificacionEdadSexo(ambiente!.id,false);
    
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot data) {
        if(data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(data.data == null){
          return Center(child:Text('No hubo resultados, esto puede ser porque no haya estudiantes en el aula solicitada'));
        }
        else{
          return Column(
            children:[
              Table(
                border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                children: [
                  TableRow(children: [
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Edad')),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Varones')),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Hembras')),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Total')),
                      )
                    ),
                  ]),
                  ...data.data[0].map((clafGeneral)=>TableRow(children: [
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? 'TOTAL' : clafGeneral['edad'].toString())),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? clafGeneral['TV'].toString() : clafGeneral['V'].toString())),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? clafGeneral['TH'].toString() : clafGeneral['H'].toString())),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? clafGeneral['TT'].toString() : clafGeneral['T'].toString())),
                      )
                    ),
                  ])).toList()
                ]
              ),
              Padding(padding:EdgeInsets.symmetric(vertical: 5)),
              Center(child:Text('Clasificación por edad y sexo',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
              Padding(padding:EdgeInsets.symmetric(vertical: 5)),
              Table(
                border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                children: [
                  TableRow(children: [
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Edad')),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Varones')),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Hembras')),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Total')),
                      )
                    ),
                  ]),
                  ...data.data[1].map((clafGeneral)=>TableRow(children: [
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? 'TOTAL' : clafGeneral['edad'].toString())),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? clafGeneral['TV'].toString() : clafGeneral['V'].toString())),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? clafGeneral['TH'].toString() : clafGeneral['H'].toString())),
                      )
                    ),
                    TableCell(
                      child:  Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text((clafGeneral['edad'] == null) ? clafGeneral['TT'].toString() : clafGeneral['T'].toString())),
                      )
                    ),
                  ])).toList()
                ]
              )
            ]
          );
        }
      },
    );
  }
}
//ESTADISTICA DE LA ASISTENCIA
class _EstadisticaAsistencia extends StatelessWidget {

  final Ambiente? ambiente;
  final int? mes;

  _EstadisticaAsistencia({required this.ambiente, required this.mes});

  Future<dynamic> onLoad()async{
    return await controladorEstadistica.getAsistencia(ambiente?.id, mes);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot data) {
        if(data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(data.data == null){
          return Center(child:Text('No hubo resultados, esto puede ser porque no haya estudiantes en el aula solicitada'));
        }
        else{
          return Table(
            border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
            children: [
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Varones')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Hembras')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Total')),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Total de asistencias')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Total']['V'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Total']['H'].toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Total']['T'].toString())),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Media')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Media']['V'].toStringAsFixed(2))),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Media']['H'].toStringAsFixed(2))),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(data.data['Media']['T'].toStringAsFixed(2))),
                  )
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('Porcentaje')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(((data.data['Porcentaje']['V'].toStringAsFixed(2) == 'NaN') ? '0.00' : data.data['Porcentaje']['V'].toStringAsFixed(2)) + '%')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(((data.data['Porcentaje']['H'].toStringAsFixed(2) == 'NaN') ? '0.00' : data.data['Porcentaje']['H'].toStringAsFixed(2)) + '%')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(((data.data['Porcentaje']['T'].toStringAsFixed(2) == 'NaN') ? '0.00' : data.data['Porcentaje']['T'].toStringAsFixed(2)) + '%')),
                  )
                ),
              ]),
            ],
          );
        }
      },
    );
  }
}