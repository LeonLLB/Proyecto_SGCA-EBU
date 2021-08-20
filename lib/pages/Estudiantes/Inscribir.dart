import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/BigFormCompound.dart';
import 'package:proyecto_sgca_ebu/components/ContainerInput.dart';
import 'package:proyecto_sgca_ebu/components/DatePicker.dart';
import 'package:proyecto_sgca_ebu/components/DualInputApellidoNombre.dart';
import 'package:proyecto_sgca_ebu/components/DualRadioInputContainer.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Representantes.dart';

class EstudianteInscribir extends StatefulWidget {
  @override
  _EstudianteInscribirState createState() => _EstudianteInscribirState();
}

enum genero { masculino, femenino, valNull }
enum procedencia { hogar, institucion, valNull }
enum tipo { regular, repitiente, valNull }

class _EstudianteInscribirState extends State<EstudianteInscribir> {
  final _formKey = GlobalKey<FormState>();

  Map<String, Map<String, dynamic>> controladores = {
    'Estudiante': {
      'Nombres': TextEditingController(),
      'Apellidos': TextEditingController(),
      'LugarNacimiento': TextEditingController(),
      'Genero': '',
      'Procedencia': '',
      'Tipo': ''
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
    return BigFormCompound(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
                Center(
                    child: Text('Estudiante',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                DualInputApellidosNombres(
                    nombreControlador: controladores['Estudiante']!['Nombres']!,
                    apellidoControlador:
                        controladores['Estudiante']!['Apellidos']!,
                    labelRest: 'estudiante',
                    icono: Icons.face),
                Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
                ContainerInput(
                    label: 'Lugar de nacimiento',
                    controlador:
                        controladores['Estudiante']!['LugarNacimiento']!,
                    icono:
                        Icon(Icons.location_on, size: 36, color: Colors.black)),
                DatePicker(
                    label: 'Fecha de Nacimiento',
                    icono: Icons.calendar_today,
                    onChanged: (String val) {}),
                DualRadioInputContainer(
                    labels: {
                      'main': 'Genero',
                      'val1': 'Masculino',
                      'val2': 'Femenino'
                    },
                    icono: Icons.face,
                    onChangeValue: (String val) {
                      controladores['Estudiante']!['Genero'] = val;
                      setState(() {});
                    }),
                Center(
                    child: Text('Representante',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                DualInputApellidosNombres(
                    apellidoControlador:
                        controladores['Representante']!['Apellidos']!,
                    nombreControlador:
                        controladores['Representante']!['Nombres']!,
                    labelRest: 'representante',
                    icono: Icons.supervisor_account),
                ContainerInput(
                    label: 'C.I Representante',
                    controlador: controladores['Representante']!['Cedula']!,
                    icono: Icon(Icons.assignment_ind,
                        size: 36, color: Colors.black)),
                ContainerInput(
                    label: 'Telefono',
                    controlador: controladores['Representante']!['Telefono']!,
                    icono: Icon(Icons.phone, size: 36, color: Colors.black)),
                ContainerInput(
                    label: 'Ubicación',
                    controlador: controladores['Representante']!['Ubicacion']!,
                    icono:
                        Icon(Icons.location_on, size: 36, color: Colors.black)),
                DualRadioInputContainer(
                    labels: {
                      'main': 'Viene de',
                      'val1': 'Hogar',
                      'val2': 'Institucion'
                    },
                    icono: Icons.school,
                    onChangeValue: (String val) {
                      controladores['Estudiante']!['Procedencia'] = val;
                      setState(() {});
                    }),
                DualRadioInputContainer(
                    labels: {
                      'main': 'Tipo de estudiante',
                      'val1': 'Regular',
                      'val2': 'Repitiente'
                    },
                    icono: Icons.face,
                    onChangeValue: (String val) {
                      controladores['Estudiante']!['Tipo'] =
                          ((val[val.length - 1]) == '2')
                              ? 'Repitiente'
                              : 'Regular';
                      setState(() {});
                    }),
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
                            side: BorderSide(
                                width: 4.0, color: Colors.blue[300]!)))),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              ],
            )));
  }
}
