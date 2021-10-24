import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';

class BuscarRepresentante extends StatefulWidget {

  @override
  _BuscarRepresentanteState createState() => _BuscarRepresentanteState();
}

class _BuscarRepresentanteState extends State<BuscarRepresentante> {

  final _formKey = GlobalKey<FormState>();

  Future<List<Representante>?> listaRepresentantes = controladorRepresentante.buscarRepresentantes(null);

  TextEditingController controlador = TextEditingController();

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
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff7C83FD), width: 4),
                borderRadius: BorderRadius.circular(20)
              ),      
              child: Column(children: [
                Row(
                  children: [
                    SimplifiedTextFormField(
                      controlador: controlador,
                      labelText: 'Cedula de identidad',
                      validators: TextFormFieldValidators(charLength: 11,isNumeric:true)
                    ),
                  ],
                ),
                Divider(),
                TextButton.icon(
                  onPressed: (){
                    listaRepresentantes = controladorRepresentante.buscarRepresentantes(
                      (controlador.text != '') ? int.parse(controlador.text) : null
                    );
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
          future: listaRepresentantes,
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
                        Text('${snapshot.data[i].nombres} ${snapshot.data[i].apellidos}',
                          style:TextStyle(fontWeight:FontWeight.bold)),
                        Row(children: [
                          Row(children: [
                            Text('C.I: ',style:TextStyle(fontWeight:FontWeight.bold)),
                            Text(snapshot.data[i].cedula.toString()),
                          ]),
                          Text(snapshot.data[i].numero)
                        ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                        Text('${snapshot.data[i].ubicacion}',
                          style:TextStyle(fontWeight:FontWeight.bold)),
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