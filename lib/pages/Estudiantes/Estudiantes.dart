import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/components/MenuButtonContainer.dart';
import 'package:proyecto_sgca_ebu/providers/AccessProvider.dart';

class Estudiantes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(2),
      children: (context.watch<AccessProvider>().rol == 'admin')
          ? swapMenu(1)
          : swapMenu(2),
    );
  }

  List<Widget> swapMenu(int version) {
    if (version == 1 /* ADMIN */) {
      return [
        MenuButtonContainer(texts: {
          'label': 'Inscribir Estudiante',
          'desc': 'Realizar la inscripción inicial de un estudiante'
        }, icon: Icons.person_add, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Actualizar Estudiante',
          'desc':
              'Realizar la inscripcrión o actualizacion regular de un estudiante'
        }, icon: Icons.create, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Buscar Estudiante',
          'desc': 'Buscar un estudiante en el sistema'
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Matricula de Estudiantes',
          'desc': 'Matricula de los estudiantes de un grado en especifico'
        }, icon: Icons.face, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Rendimiento',
          'desc': 'Subir rendimiento de los estudiantes en el año escolar'
        }, icon: Icons.add_chart_outlined, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Asistencia',
          'desc': 'Subir la asistencia de la semana de los estudiantes'
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Generar Estadistica',
          'desc': 'Generar la estadistica de asistencia de un grado especifico'
        }, icon: Icons.timeline, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ];
    } else {
      return [
        MenuButtonContainer(texts: {
          'label': 'Matricula de Estudiantes',
          'desc': 'Matricula de los estudiantes de 4to "A"'
        }, icon: Icons.face, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Rendimiento',
          'desc': 'Subir rendimiento de los estudiantes en el año escolar'
        }, icon: Icons.add_chart_outlined, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Asistencia',
          'desc': 'Subir la asistencia de la semana de los estudiantes'
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
      ];
    }
  }
}
