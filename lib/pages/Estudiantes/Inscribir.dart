import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/BigFormCompound.dart';
import 'package:proyecto_sgca_ebu/components/ConfirmDialog.dart';
import 'package:proyecto_sgca_ebu/components/ContainerInput.dart';
import 'package:proyecto_sgca_ebu/components/DatePicker.dart';
import 'package:proyecto_sgca_ebu/components/DualInputApellidoNombre.dart';
import 'package:proyecto_sgca_ebu/components/DualRadioInputContainer.dart';
import 'package:proyecto_sgca_ebu/components/FailedFormDialog.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Representantes.dart';
import 'package:proyecto_sgca_ebu/functions/crearCedulaEscolar.dart';
import 'package:proyecto_sgca_ebu/functions/printMap.dart';
import 'package:proyecto_sgca_ebu/functions/tecMapToPlainMap.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Representantes.dart';

class EstudianteInscribir extends StatefulWidget {
  @override
  _EstudianteInscribirState createState() => _EstudianteInscribirState();
}

class _EstudianteInscribirState extends State<EstudianteInscribir> {
  final _formKey = GlobalKey<FormState>();

  Map<String, Map<String, dynamic>> controladores = {
    'Estudiante': {
      'Nombres': TextEditingController(),
      'Apellidos': TextEditingController(),
      'LugarNacimiento': TextEditingController(),
      'FechaNacimiento': '',
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

  bool representanteChangedDynamic = false;

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
                //INFORMACION DEL ESTUDIANTE
                Center(
                    child: Text('Estudiante',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                //NOMBRE Y APELLIDO
                DualInputApellidosNombres(
                    nombreControlador: controladores['Estudiante']!['Nombres']!,
                    apellidoControlador:
                        controladores['Estudiante']!['Apellidos']!,
                    labelRest: 'estudiante',
                    icono: Icons.face),
                Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
                // LUGAR DE NACIMIENTO
                ContainerInput(
                    label: 'Lugar de nacimiento',
                    controlador:
                        controladores['Estudiante']!['LugarNacimiento']!,
                    icono:
                        Icon(Icons.location_on, size: 36, color: Colors.black)),
                //FECHA DE NACIMIENTO
                DatePicker(
                    label: 'Fecha de Nacimiento',
                    icono: Icons.calendar_today,
                    onChanged: (String val) {
                      controladores['Estudiante']!['FechaNacimiento'] = val;
                      setState(() {});
                    }),
                //GENERO
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
                // INFORMACION ADICIONAL DEL REPRESENTANTE
                Center(
                    child: Text('Representante',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                //CEDULA
                ContainerInput(
                  label: 'C.I Representante',
                  controlador: controladores['Representante']!['Cedula']!,
                  icono:
                      Icon(Icons.assignment_ind, size: 36, color: Colors.black),
                  validators: {'required': true, 'numeric': true},
                  afterMathChanged: (String val) {
                    if (int.tryParse(val) != null) {
                      controlesRepresentantes
                          .obtenerRepresentantePorCedula(int.parse(val))
                          .then((representante) {
                        if (representante != null) {
                          controladores['Representantes'] = {
                            'Nombres': TextEditingController(
                                text: representante.nombres),
                            'Apellidos': TextEditingController(
                                text: representante.apellidos),
                            'Cedula': TextEditingController(text: val),
                            'Telefono': TextEditingController(
                                text: representante.telefono),
                            'Ubicacion': TextEditingController(
                                text: representante.ubicacion),
                          };
                          representanteChangedDynamic = true;
                          setState(() {});
                        } else {
                          representanteChangedDynamic = false;
                          setState(() {});
                        }
                      });
                    }
                  },
                ),
                //NOMBRE Y APELLIDO
                DualInputApellidosNombres(
                    apellidoControlador:
                        controladores['Representante']!['Apellidos']!,
                    nombreControlador:
                        controladores['Representante']!['Nombres']!,
                    labelRest: 'representante',
                    icono: Icons.supervisor_account,
                    unEditable: representanteChangedDynamic),
                //TELEFONO
                ContainerInput(
                    label: 'Telefono',
                    controlador: controladores['Representante']!['Telefono']!,
                    icono: Icon(Icons.phone, size: 36, color: Colors.black),
                    validators: {'required': true, 'numeric': true},
                    unEditable: representanteChangedDynamic),
                ContainerInput(
                    label: 'Ubicación',
                    controlador: controladores['Representante']!['Ubicacion']!,
                    icono:
                        Icon(Icons.location_on, size: 36, color: Colors.black),
                    unEditable: representanteChangedDynamic),
                //DE DONDE VIENE EL ESTUDIANTE
                // SI ES DEL HOGAR, ENTONCES DEBE IR AL PRIMER GRADO
                // SI ES DE OTRA INSTITUCION, SE DEBE DE ESPECIFICAR EL GRADO
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
                //QUE TIPO DE ESTUDIANTE ES
                // SI ES REGULAR, Y VIENE DE OTRA INSTITUCION, SE DEBE ESPECIFICAR EL ULTIMO GRADO CURSADO
                // SI ES REGULAR Y VIENE DEL HOGAR, SU GRADO ES 1
                // SI ES REPITIENTE Y VIENE DE OTRA INSTITUCION, SE DEBE MARCAR EL GRADO QUE REPITE
                // SI ES REPITIENTE, NO PUEDE VENIR DEL HOGAR
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
                        inscribir(context);
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

  Future<void> inscribir(BuildContext context) async {
    if (controladores['Estudiante']!['FechaNacimiento'] != '' &&
        controladores['Estudiante']!['Genero'] != '' &&
        controladores['Estudiante']!['Procedencia'] != '' &&
        controladores['Estudiante']!['Tipo'] != '') {
      final Estudiante estudiante =
          Estudiante.fromJson(tecMapToPlainMap(controladores['Estudiante']!));

      final Representante representante = Representante.fromJson(
          tecMapToPlainMap(controladores['Representante']!));

      estudiante.cedula =
          await crearCedulaEscolar(representante.cedula, DateTime.now().year);

      final List<Text> detalles = [
        Text('Estudiante'),
        Text('${estudiante.nombres} ${estudiante.apellidos}'),
        Text('C.I Escolar: ${estudiante.cedulaEscolar}'),
        Text('Edad: 8 Años'), //TODO: CALCULAR EDAD MEDIANTE FECHA DE NACIMIENTO
        Text(' '),
        Text('Representante'),
        Text('${representante.nombres} ${representante.apellidos}'),
        Text('C.I: ${representante.cedula} '),
      ];

      await mostrarConfirmacionFormulario(detalles, context, () {
        final response =
            controlesEstudiante.inscribirInicial(estudiante, representante);
      });
    } else {
      List<String> camposANombrar = [];

      for (var campo in controladores['Estudiante']!.entries) {
        if (campo.value.runtimeType == String && campo.value == '') {
          camposANombrar.add(campo.key);
        }
      }

      formularioFallido(camposANombrar, context);
    }
  }

  Future<void> formularioFallido(
      List<String> camposANombrar, BuildContext context) async {
    List<Text> detalles = [Text('Faltan los siguientes campos:')];

    for (var campo in camposANombrar) {
      detalles.add(Text('- $campo'));
    }

    return await mostrarFalloFormulario(
        'Error al inscribir', detalles, context);
  }
}
