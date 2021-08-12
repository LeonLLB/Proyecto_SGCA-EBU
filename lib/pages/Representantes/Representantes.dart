import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/components/MenuButtonContainer.dart';
import 'package:proyecto_sgca_ebu/providers/AccessProvider.dart';

class Representantes extends StatelessWidget {
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
          'label': 'Inscribir Representante',
          'desc': 'Realizar la inscripción de un representante'
        }, icon: Icons.person_add, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Actualizar Representante',
          'desc': 'Actualizar la información de un representante'
        }, icon: Icons.create, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Buscar un Representante',
          'desc': 'Buscar un representante por su cedula de identidad'
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Visualizar representantes',
          'desc':
              'Visualizar los representantes de un grado y sección en especifico'
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ];
    } else {
      return [
        MenuButtonContainer(texts: {
          'label': 'Buscar un Representante',
          'desc': 'Buscar un representante por su cedula de identidad'
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Visualizar representantes',
          'desc': 'Visualizar los representantes de 4to "A" '
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
      ];
    }
  }
}
