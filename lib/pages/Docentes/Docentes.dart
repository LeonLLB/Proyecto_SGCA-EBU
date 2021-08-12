import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/components/MenuButtonContainer.dart';

class Docentes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(2),
      children: [
        MenuButtonContainer(texts: {
          'label': 'Inscribir Docente',
          'desc': 'Realizar la inscripción de un docente al sistema'
        }, icon: Icons.person_add, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Buscar Docente',
          'desc': 'Buscar un docente en el sistema'
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Asignar Docente',
          'desc': 'Asignar un docente a un grado y seccion especifico'
        }, icon: Icons.note_add, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Actualizar Docente',
          'desc': 'Actualizar la información personal de un docente'
        }, icon: Icons.create, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Matricula de Docentes',
          'desc': 'Visualizar la actual matricula de docentes'
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ],
    );
  }
}
