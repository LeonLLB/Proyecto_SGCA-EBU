import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';

class BuscarEstudiante extends StatefulWidget {

  @override
  _BuscarEstudianteState createState() => _BuscarEstudianteState();
}

class _BuscarEstudianteState extends State<BuscarEstudiante> {

  Future<List<Map<String,Object?>>> listaEstudiantes = controladorEstudiante.getEstudiantes(null,null);

  final _formKey = GlobalKey<FormState>();

  Map<String,TextEditingController> controladores = {
    'CedulaE':TextEditingController(),
    'CedulaR':TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * (5/10) - 200,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff7C83FD), width: 4),
                borderRadius: BorderRadius.circular(20)
              ),      
              child: Column(children: [
                Row(
                  children: [
                    SimplifiedTextFormField(
                      controlador: controladores['CedulaE']!,
                      labelText: 'Cedula escolar',
                      validators: TextFormFieldValidators(charLength: 11,isNumeric:true)
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    SimplifiedTextFormField(
                      controlador: controladores['CedulaR']!,
                      labelText: 'Cedula representante',
                      validators: TextFormFieldValidators(charLength: 9,isNumeric:true)
                    ),
                  ],
                ),
                Divider(),
                TextButton.icon(
                  onPressed: (){
                    listaEstudiantes = controladorEstudiante.getEstudiantes(
                      controladores['CedulaE']!.text == '' ? null : int.parse(controladores['CedulaE']!.text),
                      controladores['CedulaR']!.text == '' ? null : int.parse(controladores['CedulaR']!.text));

                    setState((){});
                  },
                  icon: Icon(Icons.search),
                  label: Text('Buscar')
                )
              ])
            ),
          )
        ),
        Padding(padding:EdgeInsets.symmetric(horizontal:10)),
        FutureBuilder(
          future: listaEstudiantes,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData && snapshot.data.length > 0){
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (_,__)=>Padding(padding:EdgeInsets.symmetric(vertical:10)),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff7C83FD), width: 4),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child:Column(children:[
                        Text('${snapshot.data[i]["estudiante.nombres"]} ${snapshot.data[i]["estudiante.apellidos"]}',
                          style:TextStyle(fontWeight:FontWeight.bold)),
                        Row(children: [
                          Row(children: [
                            Text('C.E: ',style:TextStyle(fontWeight:FontWeight.bold)),
                            Text(snapshot.data[i]['estudiante.cedula'].toString()),
                          ]),
                          Text(calcularEdad(snapshot.data[i]["estudiante.fecha_nacimiento"]).toString() + ' años')
                        ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                        Row(children: [
                          Text(snapshot.data[i]['añoEscolar']),
                          Text(snapshot.data[i]['grado'].toString() + '° "${snapshot.data[i]['seccion']}"')
                        ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                        Text('${snapshot.data[i]["representante.nombres"]} ${snapshot.data[i]["representante.apellidos"]}',
                          style:TextStyle(fontWeight:FontWeight.bold)),
                        Row(children: [
                          Text('C.I: ',style:TextStyle(fontWeight:FontWeight.bold)),
                          Text(snapshot.data[i]['representante.cedula'].toString()),
                        ]),
                      ])
                    );
                  },
                ),
              );
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
              return Expanded(child: Center(child: CircularProgressIndicator()));
            }
            else{
              return Expanded(child: Center(child:Text('Sin resultados',
              style:TextStyle(fontSize: 20,fontWeight:FontWeight.bold))));
            }
          },
        ),
      ]),
    );
  }
}