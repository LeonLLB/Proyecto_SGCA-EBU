import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SubMenuItem.dart';

class DocentesMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.person_add, label: 'Inscribir docente',route:'-docentes/inscribir'),
            SubMenuItem(icon: Icons.search, label: 'Buscar docente',route:'-docentes/buscar'),            
            SubMenuItem(icon: Icons.note_add, label: 'Asignar docente',route:'-docentes/asignar')
          ]),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.edit, label: 'Actualizar docente',route:'-docentes/actualizar'),
            SubMenuItem(icon: Icons.assignment,label: 'Matricula de docentes',route:'-docentes/matricula')
          ])
        ]),
      );
  }
}