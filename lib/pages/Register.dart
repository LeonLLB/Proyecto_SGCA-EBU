import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/UI.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/index.dart';
import 'package:proyecto_sgca_ebu/routes.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum roles {D, A}

class _RegisterPageState extends State<RegisterPage> {

  roles nivelAcceso = roles.D;

  final _formKey = GlobalKey<FormState>();
  
  Map<String, dynamic> controladores = {
    'Nombres': TextEditingController(),
    'Apellidos': TextEditingController(),    
    'Cedula':TextEditingController(),
    'Contraseña':TextEditingController(),
    'Confirmar_Contraseña':TextEditingController(),
    'Correo': TextEditingController(),
    'Numero':TextEditingController(),
    'Direccion':TextEditingController(),
    'Rol': '',
  };

  @override
  Widget build(BuildContext context) {
    return UI(
      child: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * (8/10),
            height: MediaQuery.of(context).size.height * (7/8),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff7C83FD), width: 4),
              borderRadius: BorderRadius.circular(20)
            ),
            child: SingleChildScrollView(
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
                      TextFormFieldValidators(isNumeric: true),
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
                  RadioInputRowList<roles>(
                    groupValue: nivelAcceso,
                    values: [roles.D,roles.A],
                    labels: ['Docente','Administrador'],
                    onChanged: (val){
                      setState(() {
                        controladores['Rol'] = val.toString().split('.')[1];
                        nivelAcceso = val!;
                      });
                    }
                  ),
                  FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot data){
                      if(data.hasData && data.data as bool == false ){
                        
                        controladores['AdminCedula'] = TextEditingController();
                        controladores['AdminContraseña'] = TextEditingController();
                        
                        return Column(
                          children: [
                            Center(child:Text('Confirmación por un administrador')),
                            DoubleTextFormFields(
                              controladores: [
                                controladores['AdminCedula'],
                                controladores['AdminContraseña']
                              ],
                              iconos: [Icon(Icons.person),Icon(Icons.lock)],
                              labelTexts: ['Cedula','Contraseña'],
                              obscureTexts:[false,true],
                              validators: [
                                TextFormFieldValidators(required:true,isNumeric:true),
                                TextFormFieldValidators(required:true),
                              ]
                            ),
                          ],
                        );
                      }
                      else{
                        return Container();
                      }
                    },
                    future: controladorUsuario.existenAdministradores()
                  ),
                  TextButton(onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      if(controladores['AdminCedula'] != null && controladores['AdminContraseña'] != null){
                        final loggedInfo = await controladorUsuario.login(
                          cedula: int.parse(controladores['AdminCedula'].text),
                          password: controladores['AdminContraseña'].text
                        );
                        if( loggedInfo['logged'] ){
                          crearUsuario(controladores,context);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar(loggedInfo['error']));
                        }
                      }else{
                        crearUsuario(controladores,context);
                      }         
                      
                    }
                  }, child: Text(
                    'Registrar al sistema',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600))),
                  TextButton(onPressed: (){Navigator.pushReplacement(context, toPage('/login'));}, child: Text(
                    'Iniciar sesión',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600)))   
                ],
              ),
              ),
            )
          ),
        )
      );
  }

  void crearUsuario (Map<String, dynamic> info, BuildContext context){
    final Usuarios usuarioNuevo = Usuarios.fromForm(formInfoIntoMap(info));
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Registrando usuario...',
      onVisible: () async {        
        try {
          await controladorUsuario.registrar(usuarioNuevo);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Usuario creado con exito!'));
          Navigator.pushReplacement(context, toPage('/login'));
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al crear el usuario'));
          
        }
      },
    ));
  }
}