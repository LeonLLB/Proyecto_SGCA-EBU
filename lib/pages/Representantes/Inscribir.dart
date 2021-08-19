import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/ContainerInput.dart';
import 'package:proyecto_sgca_ebu/components/DualInputApellidoNombre.dart';

class RepresentanteInscribir extends StatefulWidget {
  @override
  _RepresentanteInscribirState createState() => _RepresentanteInscribirState();
}

class _RepresentanteInscribirState extends State<RepresentanteInscribir> {
  final _formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controladores = {
    'Nombres': TextEditingController(),
    'Apellidos': TextEditingController(),
    'Cedula': TextEditingController(),
    'Telefono': TextEditingController(),
    'Ubicacion': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          DualInputApellidosNombres(
              nombreControlador: controladores['Nombres']!,
              apellidoControlador: controladores['Apellidos']!,
              labelRest: 'representante',
              icono: Icons.supervisor_account),
          ContainerInput(
              label: 'Cedula de identidad',
              controlador: controladores['Cedula']!,
              icono: Icon(Icons.assignment_ind, size: 36, color: Colors.black)),
          ContainerInput(
              label: 'Telefono',
              controlador: controladores['Telefono']!,
              icono: Icon(Icons.phone, size: 36, color: Colors.black)),
          ContainerInput(
              label: 'Ubicación',
              controlador: controladores['Ubicacion']!,
              icono: Icon(Icons.location_on, size: 36, color: Colors.black)),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //TODO: Implementar logica de inscripcion

                }
              },
              child: Text('Inscribir representante',
                  style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(width: 4.0, color: Colors.blue[300]!)))),
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        ],
      ),
    );
  }
}
