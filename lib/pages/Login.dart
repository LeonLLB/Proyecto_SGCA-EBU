import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/SessionProvider.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/UI.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controladores = {
    'Cedula':TextEditingController(),
    'Contraseña':TextEditingController()
  };

  @override
  Widget build(BuildContext context) {
    return UI(
      child: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * (1/2),
            height: MediaQuery.of(context).size.height * (3/7),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff7C83FD), width: 4),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
              children: [
                SimplifiedTextFormField(
                  controlador: controladores['Cedula']!,
                  labelText: 'Cedula',
                  icon: Icon(Icons.person),
                  validators: TextFormFieldValidators(
                    required: true,
                    isNumeric: true,
                    charLength: 9,
                  )
                ),
                SimplifiedTextFormField(
                  controlador: controladores['Contraseña']!,
                  labelText: 'Contraseña',
                  icon: Icon(Icons.lock),
                  validators: TextFormFieldValidators(required:true),
                  obscureText: true,
                ),
                TextButton(onPressed: (){
                  if(_formKey.currentState!.validate()){

                    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                      message: 'Iniciando sesión...',
                      onVisible:()async{
                        final usuarioInfo = await controladorUsuario.login(
                          cedula: int.parse(controladores['Cedula']!.text),
                          password: controladores['Contraseña']!.text
                        );

                        if(usuarioInfo['logged']){
                          Provider.of<SessionProvider>(context,listen:false).isLogged = usuarioInfo['logged'];
                          Provider.of<SessionProvider>(context,listen:false).usuario = usuarioInfo['usuario'];
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Sesión iniciada con exito!'));
                          Navigator.pushReplacement(context,toPage('/home'));
                        }

                        else{
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Usuario o clave invalida'));
                        }
                      }
                    ));
                    
                  }
                }, child: Text(
                  'Iniciar sesión',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600))),
                TextButton(onPressed: (){Navigator.pushReplacement(context, toPage('/registrar')) ;}, child: Text(
                  'Registrar',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600)))
              ],
            ),
          )
        ),
      ),
    );
  }
}
