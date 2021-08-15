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
          'label': 'Inscribir Estudiante Inicial',
        }, icon: Icons.person_add, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Inscribir Estudiante Regular',
        }, icon: Icons.create, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Buscar Estudiante',
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Matricula de Estudiantes',
        }, icon: Icons.face, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Rendimiento',
        }, icon: Icons.add_chart_outlined, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Asistencia',
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Generar Estadistica',
        }, icon: Icons.timeline, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ];
    } else {
      return [
        MenuButtonContainer(texts: {
          'label': 'Matricula de Estudiantes',
        }, icon: Icons.face, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Rendimiento',
        }, icon: Icons.add_chart_outlined, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Subir Asistencia',
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
      ];
    }
  }
}
