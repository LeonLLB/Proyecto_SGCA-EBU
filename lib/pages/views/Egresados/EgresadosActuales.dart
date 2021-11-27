import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DateTimePicker.dart';
import 'package:proyecto_sgca_ebu/controllers/Egresados.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';

class EgresadosNuevos extends StatefulWidget {

  @override
  State<EgresadosNuevos> createState() => _EgresadosNuevosState();
}

class _EgresadosNuevosState extends State<EgresadosNuevos> {
  final consultaEgresados = controladorEgresados.getEgresadosActuales();
  String fechaGraduacionEgresados = '';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child:FutureBuilder(
          future: consultaEgresados,
          builder: (BuildContext context, AsyncSnapshot data) {
            if(data.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if(data.data == null){
              return Center(child:Text('No hay egresados pendientes para el año escolar anterior'));
            }
            else{
              return Column(children: [
                Center(child:Text('Graduandos del año escolar: ${data.data[0]['añoEscolarCursado']}',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold))),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),   
                Table(
                  border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                  children: [
                    TableRow(children: [
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Graduando')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Cedula')),
                        )
                      ),
                      TableCell(child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Representante')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Grado')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Fecha de Nacimiento')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Edad')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('Generar boletín')),
                        )
                      ),                      
                    ]),
                    ...data.data.map((egresado)=>TableRow(children: [
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('${egresado['e.nombres']} ${egresado['e.apellidos']}')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('${egresado['e.cedula']}')),
                        )
                      ),
                      TableCell(child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Column(
                            children: [
                              Text('${egresado['r.nombres']} ${egresado['r.apellidos']}'),
                              Text('C.I: ${egresado['r.cedula']}'),
                            ],
                          )),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('${egresado['grado']}° "${egresado['seccion']}"')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('${egresado['fecha_nacimiento']}')),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(calcularEdad(egresado['fecha_nacimiento']).toString())),
                        )
                      ),
                      TableCell(
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: TextButton.icon(
                            onPressed: (){},
                            icon: Icon(Icons.save),
                            label: Text(''))),
                        )
                      ),
                    ])).toList()
                  ]
                ),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),   
                DateTimePicker(
                  onChange: (fechaGraducion){},
                  defaultText: 'Fecha de graduación',
                  maxDate: DateTime.now(),
                  defaultDate: DateTime.now(),
                  lastDate: fechaGraduacionEgresados
                ),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),   
                ElevatedButton(onPressed: (){}, child: Text('Graduar estudiantes')),
                Padding(padding:EdgeInsets.symmetric(vertical:5))  
              ]);
            }
          },
        ),
      )
    );
  }
}