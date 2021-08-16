import 'package:flutter/material.dart';

class LoginPagina extends StatefulWidget {
  @override
  _LoginPaginaState createState() => _LoginPaginaState();
}

class _LoginPaginaState extends State<LoginPagina> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //TODO: Implementar el logo de la uriapara como fondo

    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: Text('SGCA-EBU'),
        )),
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              height: 265,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 4),
                  color: Colors.grey[200]),
              child: Column(children: [
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'Cedula'),
                  maxLength: 9,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Introduzca la cedula.';
                    } else if (int.tryParse(val) == null) {
                      return 'Introduzca solo números.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock), labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Introduzca la contraseña.';
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Iniciando sesión')),
                        );
                      }
                    },
                    child:
                        Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
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
                      Navigator.pushReplacementNamed(context, '/registrar');
                    },
                    child: Text('Solicita registro',
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
}
