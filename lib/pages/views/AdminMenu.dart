import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SubMenuItem.dart';

class AdminMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
        Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.post_add, label: 'Inscribir ambiente',route:'-admin/inscribirgrado'),
            SubMenuItem(icon: Icons.assignment, label: 'Ver ambientes',route:'-admin/vergrados'),            
            SubMenuItem(icon: Icons.calendar_today,label: 'Actualizar año escolar',route:'-admin/cambiarañoescolar')
          ]),
      ])
    );
  }
}