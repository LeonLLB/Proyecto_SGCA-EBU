import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/components/MenuButtonContainer.dart';
import 'package:proyecto_sgca_ebu/providers/AccessProvider.dart';
import 'package:proyecto_sgca_ebu/providers/Pesta%C3%B1aProvider.dart';

class Representantes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(2),
      children: (context.watch<AccessProvider>().rol == 'admin')
          ? swapMenu(1, context)
          : swapMenu(2, context),
    );
  }

  List<Widget> swapMenu(int version, BuildContext context) {
    if (version == 1 /* ADMIN */) {
      return [
        MenuButtonContainer(
            texts: {
              'label': 'Inscribir Representante',
            },
            icon: Icons.person_add,
            onPressed: () {
              context.read<PestanaProvider>().cambiarPagina(
                  zona: 4, numPage: 1, appBarText: 'Inscribir representante');
            }),
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
