import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SubMenuItem.dart';

class EgresadosMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.school, label: 'Ver nuevos egresos', route: '-egresados/nuevos'),
            SubMenuItem(icon: Icons.school, label: 'Consultar egresados antiguos', route: '-egresados/consulta'),
          ])
        ]),
      );
  }
}