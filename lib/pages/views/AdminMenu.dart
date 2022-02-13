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
            SubMenuItem(icon: Icons.edit, label: 'Gestionar ambientes',route:'-admin/gestiongrado'),
          ]),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
            SubMenuItem(icon: Icons.calendar_today,label: 'Actualizar año escolar',route:'-admin/cambiarañoescolar'),
            SubMenuItem(icon: Icons.person_add, label: 'Inscribir administrador',route:'-admin/inscribiradmin'),
            SubMenuItem(icon: Icons.edit, label: 'Gestionar administrador',route:'-admin/gestionaradmin'),
          ]),
      ])
    );
  }
}