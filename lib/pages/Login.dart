import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/UI.dart';

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
            height: MediaQuery.of(context).size.height * (3/8),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff7C83FD), width: 4),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
              children: [
                Expanded(
                  child: TextFormField(
                      controller: controladores['Cedula'],
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Cedula'                        
                      ),
                      maxLength:9,
                      validator: (val){
                        if (val == null || val.isEmpty) return 'Introduzca la cedula';
                        else if (int.tryParse(val) == null) return 'Introduzca solo números';
                      },
                    ),
                ),
                Expanded(
                  child: TextFormField(
                      controller: controladores['Contraseña'],
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Contraseña'                        
                      ),
                      obscureText:true,
                      validator: (val){
                        if (val == null || val.isEmpty) return 'Introduzca la contraseña';
                      },
                    ),
                ),
                TextButton(onPressed: (){}, child: Text(
                  'Iniciar sesión',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600))),
                TextButton(onPressed: (){}, child: Text(
                  'Registrar',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600)))
              ],
            ),
          )
        ),
      ),
    );
  }
}
