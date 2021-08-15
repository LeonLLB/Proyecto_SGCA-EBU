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
        }, icon: Icons.person_add, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Actualizar Representante',
        }, icon: Icons.create, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Buscar un Representante',
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Visualizar representantes',
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ];
    } else {
      return [
        MenuButtonContainer(texts: {
          'label': 'Buscar un Representante',
        }, icon: Icons.search, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
        MenuButtonContainer(texts: {
          'label': 'Visualizar representantes',
        }, icon: Icons.assignment, onPressed: () {}),
        Padding(padding: EdgeInsets.symmetric(vertical: 0.5)),
      ];
    }
  }
}
