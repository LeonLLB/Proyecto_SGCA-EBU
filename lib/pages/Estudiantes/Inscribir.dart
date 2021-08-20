import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/ContainerInput.dart';
import 'package:proyecto_sgca_ebu/components/DualInputApellidoNombre.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Representantes.dart';

class EstudianteInscribir extends StatefulWidget {
  @override
  _EstudianteInscribirState createState() => _EstudianteInscribirState();
}

class _EstudianteInscribirState extends State<EstudianteInscribir> {
  final _formKey = GlobalKey<FormState>();

  Map<String, Map<String, TextEditingController>> controladores = {
    'Estudiante': {
      'Nombres': TextEditingController(),
      'Apellidos': TextEditingController(),
      'LugarNacimiento': TextEditingController(),
    },
    'Representante': {
      'Nombres': TextEditingController(),
      'Apellidos': TextEditingController(),
      'Cedula': TextEditingController(),
      'Telefono': TextEditingController(),
      'Ubicacion': TextEditingController(),
    }
  };

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
            Center(
                child: Text('Estudiante',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            DualInputApellidosNombres(
                nombreControlador: controladores['Estudiante']!['Nombres']!,
                apellidoControlador: controladores['Estudiante']!['Apellidos']!,
                labelRest: 'estudiante',
                icono: Icons.face),
            Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
            ContainerInput(
                label: 'Lugar de nacimiento',
                controlador: controladores['Estudiante']!['LugarNacimiento']!,
                icono: Icon(Icons.location_on, size: 36, color: Colors.black)),
            //TODO: FECHA DE NACIMIENTO
            //TODO: GENEROS
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 4),
                  color: Colors.grey[200]),
            ),
            Center(
                child: Text('Representante',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            DualInputApellidosNombres(
                apellidoControlador:
                    controladores['Representante']!['Apellidos']!,
                nombreControlador: controladores['Representante']!['Nombres']!,
                labelRest: 'representante',
                icono: Icons.supervisor_account),
            ContainerInput(
                label: 'C.I Representante',
                controlador: controladores['Representante']!['Cedula']!,
                icono:
                    Icon(Icons.assignment_ind, size: 36, color: Colors.black)),
            ContainerInput(
                label: 'Telefono',
                controlador: controladores['Representante']!['Telefono']!,
                icono: Icon(Icons.phone, size: 36, color: Colors.black)),
            ContainerInput(
                label: 'Ubicación',
                controlador: controladores['Representante']!['Ubicacion']!,
                icono: Icon(Icons.location_on, size: 36, color: Colors.black)),
            //TODO: CONDICIONES DE INGRESO

            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //TODO: Implementar logica de inscripcion

                  }
                },
                child: Text('Inscribir estudiante y representante',
                    style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            BorderSide(width: 4.0, color: Colors.blue[300]!)))),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          ],
        ));
  }
}
