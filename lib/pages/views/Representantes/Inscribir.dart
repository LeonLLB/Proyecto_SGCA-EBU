import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';

class InscribirRepresentante extends StatefulWidget {

  @override
  _InscribirRepresentanteState createState() => _InscribirRepresentanteState();
}

class _InscribirRepresentanteState extends State<InscribirRepresentante> {

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> controladoresRepresentante = {
      'Nombres':TextEditingController(),
      'Apellidos':TextEditingController(),
      'Cedula':TextEditingController(),
      'Numero':TextEditingController(),
      'Ubicacion':TextEditingController(),
    };
  
  void resetForm(){
    controladoresRepresentante = {
      'Nombres':TextEditingController(),
      'Apellidos':TextEditingController(),
      'Cedula':TextEditingController(),
      'Numero':TextEditingController(),
      'Ubicacion':TextEditingController(),
    };setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * (9/10) - 200,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff7C83FD), width: 4),
                borderRadius: BorderRadius.circular(20)
              ),      
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
                children:[
                  DoubleTextFormFields(
                    controladores: [
                      controladoresRepresentante['Nombres'],
                      controladoresRepresentante['Apellidos']
                    ],
                    iconos: [Icon(Icons.person)],
                    labelTexts: ['Nombres','Apellidos'],
                    validators: [
                      TextFormFieldValidators(required:true,isNotNumeric:true),                   
                      TextFormFieldValidators(required:true,isNotNumeric:true)
                    ]
                  ),
                  DoubleTextFormFields(
                    controladores: [
                      controladoresRepresentante['Cedula'],
                      controladoresRepresentante['Numero']
                    ],
                    iconos: [
                      Icon(Icons.assignment_ind),
                      Icon(Icons.phone)
                    ],
                    labelTexts: ['Cedula','Telefono'],
                    validators: [
                      TextFormFieldValidators(required:true,isNumeric:true,charLength:9),                  
                      TextFormFieldValidators(required:true,isNumeric:true,charLength:11)
                    ]
                  ),
                  Row(
                    children: [
                      SimplifiedTextFormField(
                        controlador: controladoresRepresentante['Ubicacion'],
                        labelText: 'Dirección',
                        validators: TextFormFieldValidators(required:true),
                        icon: Icon(Icons.location_on)
                      ),
                    ],
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  TextButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        final inscripcionConfirmada = await confirmarInscripcion(
                          controladoresRepresentante,context
                        );
                        if(inscripcionConfirmada != null && inscripcionConfirmada){
                          crearRepresentante(controladoresRepresentante,context);
                        }
                      }
                    },
                    child: Text('Inscribir representante',
                      style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600))
                  )
                ]
              )
            )
          )
        )
      )
    );
  }

  Future<bool?> confirmarInscripcion(
    Map<String, dynamic> infoRepresentante,
    BuildContext context
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar inscripción'),
        content: SingleChildScrollView(
          child: Center(
            child: ListBody(
              children: [
                Center(child: Text('Representante',style:TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text('${infoRepresentante["Nombres"].text} ${infoRepresentante["Apellidos"].text}',style:TextStyle(fontWeight: FontWeight.bold))),
                Center(
                  child: Row(children: [
                    Text('C.I: ',style:TextStyle(fontWeight: FontWeight.bold)),
                    Text(infoRepresentante["Cedula"].text)
                  ]),
                ),
              ],
            ),
          )
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void crearRepresentante(
    Map<String, dynamic> infoRepresentante,
    BuildContext context
  ) async {

    final representanteExistente = await controladorRepresentante.buscarRepresentante(int.parse(infoRepresentante['Cedula'].text));
    if(representanteExistente == null){
      final Representante representanteAInscribir = Representante.fromForm(formInfoIntoMap(infoRepresentante));
      
      ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
        message:'Registrando representante...',
        onVisible: () async {
          try {
            await controladorRepresentante.registrar(representanteAInscribir);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Representante creado con exito!'));
            resetForm();
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al crear el representante'));
          }
        }
      ));
        
    }else{
      showDialog<void>(context: context, builder: (_)=>AlertDialog(
        title: const Text('Error'),
          content: SingleChildScrollView(
            child: Center(
              child: ListBody(
                children: [
                  Center(child: Text('Ya existe el representante para esa cedula',style:TextStyle(fontWeight: FontWeight.bold))),
                  Center(child: Text('${representanteExistente.nombres} ${representanteExistente.apellidos}',style:TextStyle(fontWeight: FontWeight.bold))),
                  Center(
                    child: Row(children: [
                      Text('C.I: ',style:TextStyle(fontWeight: FontWeight.bold)),
                      Text(representanteExistente.cedula.toString())
                    ]),
                  ),
                ]
              )
            )
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('OK'),
            ),
          ],          
        )
      );
    }

  }
}