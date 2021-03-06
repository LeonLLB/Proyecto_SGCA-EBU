import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/SessionProvider.dart';
import 'package:proyecto_sgca_ebu/components/SubMenuItem.dart';

class EstudiantesMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context,listen:false).usuario;
    return (session.rol == 'A')?AdminEstudiantesList():DocenteEstudiantesList();
  }
}

class AdminEstudiantesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return Expanded(
      child: ListView(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.person_add, label: 'Inscribir estudiante', route: '-estudiantes/inscribir'),
            SubMenuItem(icon: Icons.edit, label: 'Ficha de inscripcion', route: '-estudiantes/fichaestudiante'),
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
            SubMenuItem(icon: Icons.person_remove, label: 'Retiro estudiantil', route: '-estudiantes/retiro'),
          ])
        ]),
      );
  }
}

class DocenteEstudiantesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [            
            SubMenuItem(icon: Icons.face, label: 'Matricula de estudiantes', route: '-estudiantes/matricula'),
            SubMenuItem(icon: Icons.bar_chart,label: 'Subir asistencia', route: '-estudiantes/asistencia'),
          ]),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.show_chart, label: 'Subir rendimiento', route: '-estudiantes/rendimiento'),
            SubMenuItem(icon: Icons.show_chart_sharp, label: 'Generar estadistica', route: '-estudiantes/estadistica'),
          ]),
        ]),
      );
  }
}