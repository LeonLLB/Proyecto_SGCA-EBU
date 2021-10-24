import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Usuarios.dart';

class InscribirDocente extends StatefulWidget {
  
  @override
  _InscribirDocenteState createState() => _InscribirDocenteState();
}

class _InscribirDocenteState extends State<InscribirDocente> {
  final _formKey = GlobalKey<FormState>();

  final String rol = 'D';

  Map<String, dynamic> controladores = {
    'Nombres': TextEditingController(),
    'Apellidos': TextEditingController(),    
    'Cedula':TextEditingController(),
    'Contraseña':TextEditingController(),
    'Confirmar_Contraseña':TextEditingController(),
    'Correo': TextEditingController(),
    'Numero':TextEditingController(),
    'Direccion':TextEditingController(),
  };

  void resetForm(){
    controladores = {
    'Nombres': TextEditingController(),
    'Apellidos': TextEditingController(),    
    'Cedula':TextEditingController(),
    'Contraseña':TextEditingController(),
    'Confirmar_Contraseña':TextEditingController(),
    'Correo': TextEditingController(),
    'Numero':TextEditingController(),
    'Direccion':TextEditingController(),
    };
    setState((){});
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
                children: [
                DoubleTextFormFields(
                  controladores: [
                    controladores['Nombres'],
                    controladores['Apellidos']
                  ],                
                  iconos: [Icon(Icons.person)],
                  labelTexts: ['Nombres','Apellidos'],
                  validators: [
                    TextFormFieldValidators(required: true,isNotNumeric:true),
                    TextFormFieldValidators(required: true,isNotNumeric:true)
                  ]
                ),
                DoubleTextFormFields(
                  controladores: [
                    controladores['Cedula'],
                    controladores['Numero']
                  ],
                  iconos: [
                    Icon(Icons.person),
                    Icon(Icons.phone)
                  ],
                  labelTexts: ['Cedula','Número'],
                  validators: [
                    TextFormFieldValidators(
                      required:true,
                      isNumeric: true,
                      charLength:9
                    ),
                    TextFormFieldValidators(isNumeric: true,charLength:11),
                  ]
                ),
                DoubleTextFormFields(
                  controladores: [
                    controladores['Correo'],
                    controladores['Direccion']
                  ],
                  iconos: [
                    Icon(Icons.mail),
                    Icon(Icons.location_on)
                  ],
                  labelTexts: [
                    'Correo electronico',
                    'Direccion'
                  ],
                  validators: [
                    TextFormFieldValidators(isEmail: true),
                    TextFormFieldValidators()
                  ]
                ),
                DoubleTextFormFields(
                  controladores: [
                    controladores['Contraseña'],
                    controladores['Confirmar_Contraseña']
                  ],
                  iconos: [
                    Icon(Icons.lock),
                    Icon(Icons.lock)
                  ],
                  labelTexts: ['Contraseña','Confirmar contraseña'],
                  obscureTexts: [true,true],
                  validators: [
                    TextFormFieldValidators(required:true),
                    TextFormFieldValidators(required:true,extraValidator:(val){
                      if(val != controladores['Contraseña'].text) return 'Las contraseñas no coinciden';
                    })
                  ]
                ),
                TextButton(onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    
                      final inscripcionConfirmada =  await confirmarInscripcion(
                        controladores,context
                      );

                      if(inscripcionConfirmada != null && inscripcionConfirmada){
                        controladores['Rol'] = rol;
                        crearDocente(controladores,context);
                      }
                    
                  }
                },child: Text('Inscribir docente',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600)))
                ]
                ),
              )
            )
          )
        )
      );
  }

  Future<bool?> confirmarInscripcion(
    Map<String, dynamic> infoDocente, BuildContext context)
    => showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirmar inscripción'),
          content: SingleChildScrollView(
            child: Center(
              child: ListBody(
                children: [
                  Center(child: Text('Docente',style:TextStyle(fontWeight: FontWeight.bold))),
                  Center(child: Text('${infoDocente["Nombres"].text} ${infoDocente["Apellidos"].text}',style:TextStyle(fontWeight: FontWeight.bold))),
                  Center(
                    child: Row(children: [
                      Text('C.I: ',style:TextStyle(fontWeight: FontWeight.bold)),
                      Text(infoDocente["Cedula"].text)
                    ]),
                  ),
                  Center(child: Text('${(infoDocente["Correo"].text != '') ? infoDocente["Correo"].text : "Sin correo" }')),
                  Center(child: Text('${(infoDocente["Numero"].text != '') ? infoDocente["Numero"].text : "Sin teléfono"}')),
                  Center(child: Text('${(infoDocente["Direccion"].text != '') ? infoDocente["Direccion"].text : "Sin ubicación"}')),
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

  void crearDocente(Map<String, dynamic> infoDocente, BuildContext context) {
    final Usuarios docenteNuevo = Usuarios.fromForm(formInfoIntoMap(infoDocente));
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Registrando docente...',
      onVisible: () async {        
        try {
          await controladorUsuario.registrar(docenteNuevo);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Docente creado con exito!'));
          resetForm();
        } catch (e) {
          if(e.toString().contains('UNIQUE constraint failed')){
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Ya existe un docente con esa cedula'));
          }
          else {
            print(e);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al crear el docente'));
          }
          
        }
      },
    ));
  }
}