import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SubMenuItem.dart';

class RepresentantesMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.person_add, label: 'Inscribir representante',route: '-representantes/inscribir'),
            SubMenuItem(icon: Icons.edit, label: 'Actualizar representante',route: '-representantes/actualizar'),
          ]),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.search, label: 'Buscar representante',route: '-representantes/buscar'),            
            SubMenuItem(icon: Icons.assignment,label: 'Visualizar representantes',route: '-representantes/visualizar')
          ])
        ]),
      );
  }
}