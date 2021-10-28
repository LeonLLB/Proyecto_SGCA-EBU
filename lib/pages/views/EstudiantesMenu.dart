import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SubMenuItem.dart';

class EstudiantesMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.person_add, label: 'Inscribir estudiante', route: '-estudiantes/inscribir'),
            SubMenuItem(icon: Icons.edit, label: 'Actualizar estudiante', route: '-estudiantes/actualizar'),
            SubMenuItem(icon: Icons.face, label: 'Matricula de estudiantes', route: '-estudiantes/matricula')
          ]),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.search, label: 'Buscar estudiante', route: '-estudiantes/buscar'),
            SubMenuItem(icon: Icons.bar_chart,label: 'Subir asistencia', route: '-estudiantes/asistencia'),
            SubMenuItem(icon: Icons.show_chart, label: 'Subir rendimiento', route: '-estudiantes/rendimiento')
          ]),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.show_chart_sharp, label: 'Generar estadistica', route: '-estudiantes/estadistica'),
            SubMenuItem(icon: Icons.school, label: 'Constancia de estudio', route: '-estudiantes/constancia'),
          ])
        ]),
      );
  }
}