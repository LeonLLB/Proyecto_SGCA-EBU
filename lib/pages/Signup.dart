import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controladores = {
    'Nombres': TextEditingController(),
    'Apellidos': TextEditingController(),
    'Cedula': TextEditingController(),
    'Correo': TextEditingController(),
    'Telefono': TextEditingController(),
    'Contraseña': TextEditingController(),
    'Contraseña2': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    //TODO: Implementar el logo de la uriapara como fondo

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text('SGCA-EBU'),
            )),
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              height: 600,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 4),
                  color: Colors.grey[200]),
              child: ListView(children: [
                textFormField(
                    icon: Icon(Icons.person),
                    label: 'Nombres',
                    validatorText: 'Ingrese sus nombres.'),
                textFormField(
                    icon: Icon(Icons.person),
                    label: 'Apellidos',
                    validatorText: 'Ingrese sus apellidos.'),
                textFormField(
                    icon: Icon(Icons.assignment_ind),
                    label: 'Cedula',
                    validatorText: 'Ingrese su cedula.'),
                textFormField(
                    icon: Icon(Icons.email),
                    label: 'Correo electronico',
                    controlador: 'Correo',
                    validatorText: 'Ingrese su email.'),
                textFormField(
                    icon: Icon(Icons.phone),
                    label: 'Telefono',
                    validatorText: 'Ingrese su telefono.'),
                textFormField(
                    icon: Icon(Icons.lock),
                    label: 'Contraseña',
                    validatorText: 'Ingrese una contraseña',
                    isPassword: true),
                textFormField(
                    icon: Icon(Icons.lock),
                    label: 'Repita la contraseña',
                    controlador: 'Contraseña2',
                    validatorText: 'Ingrese su contraseña',
                    isPassword: true),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Enviando solicitud...',
                                        style: TextStyle(color: Colors.black)),
                                    CircularProgressIndicator(
                                        color: Colors.black)
                                  ]),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.blue[300]!))),
                        );
                        //TODO: Implementar logica de registro de sesión

                        //Navigator.pushNamed(context, '/login');
                      }
                    },
                    child: Text('Solicitar registro',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                width: 4.0, color: Colors.blue[300]!)))),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Ya tiene cuenta? Iniciar sesión.',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                width: 4.0, color: Colors.blue[300]!))))
              ]),
            ),
          ),
        ));
  }

  TextFormField textFormField(
      {required Icon icon,
      required String label,
      required String validatorText,
      bool isPassword: false,
      String? controlador}) {
    return TextFormField(
      decoration: InputDecoration(icon: icon, labelText: label),
      controller: controladores[(controlador == null) ? label : controlador],
      obscureText: isPassword,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return validatorText;
        }
      },
    );
  }
}
