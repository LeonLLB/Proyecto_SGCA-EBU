import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';

class VisualizarRepresentante extends StatefulWidget {

  @override
  State<VisualizarRepresentante> createState() => _VisualizarRepresentanteState();
}

class _VisualizarRepresentanteState extends State<VisualizarRepresentante> {

  TextEditingController controladorConsulta = TextEditingController();

  Future<List<Map<String,Object?>>?> consultaRepresentante = controladorRepresentante.getRepresentanteYEstudiantes(null);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width * (6/10) - 200;

    return Expanded(
      child: SingleChildScrollView(
        child:Column(children: [
      Center(
        child: SimplifiedContainer(            
          width: width,
          child:Row(
            children: [
              SimplifiedTextFormField(
                controlador: controladorConsulta,
                labelText: 'Cedula',
                validators: TextFormFieldValidators(required:true,isNumeric:true),  
              ),
            VerticalDivider(),
            TextButton.icon(
              onPressed: (){
                consultaRepresentante = controladorRepresentante.getRepresentanteYEstudiantes(controladorConsulta.text == '' ? null: int.parse(controladorConsulta.text));
                setState((){}); 
              },
              icon: Icon(Icons.search),
              label: Text('Buscar')
            )
          ])
        )
      ),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
      FutureBuilder(
        future: consultaRepresentante,
        builder: (BuildContext context, AsyncSnapshot data) {
          if(data.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(data.data == null){
            return Center(child:Text('No existe el representante solicitado'));
          }
          else if(data.data[0]['e.nombres'] == null){
            return Center(child:Text('El representante existe, pero no tiene estudiantes'));
          }
          else{
            return Container(
              width: MediaQuery.of(context).size.width - 200 ,
              child: Column(children: [
                SimplifiedContainer(
                  width: width,
                  child: Column(children: [
                    Text('${data.data[0]['nombres']} ${data.data[0]['apellidos']}'),
                    Text('C.I: ${data.data[0]['cedula']}'),
                    Text('Telefono: ${data.data[0]['numero']}'),
                    Text('Ubicación: ${data.data[0]['ubicacion']}'),
                  ])
                ),
                Padding(padding:EdgeInsets.symmetric(vertical: 5)),              
                Table(
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
                            child: Center(child: Text('Cedula')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Fecha de nacimiento')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Edad')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Genero')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Aula')),
                          )
                        ),
                        TableCell(
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text('Parentesco')),
                          )
                        )
                      ]
                    ),
                    ...data.data.map((estudiante)=>TableRow(children:[
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(estudiante['e.nombres'])),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(estudiante['e.apellidos'])),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(estudiante['e.cedula'].toString(),style:TextStyle(fontSize:12.5))),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(estudiante['e.fecha_nacimiento'])),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(calcularEdad(estudiante['e.fecha_nacimiento']).toString())),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(estudiante['e.genero'] == 'M' ? 'Varón' : 'Hembra')),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text('${estudiante['grado']}° "${estudiante['seccion']}"')),
                        )
                      ),
                      TableCell(
                        child:  Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(child: Text(estudiante['parentesco'] == null ? 'N/A' : estudiante['parentesco'] )),
                        )
                      )
                    ])).toList()
                  ]
                )
              ]),
            );
          }
        },
      ),
    ])));
  }
}