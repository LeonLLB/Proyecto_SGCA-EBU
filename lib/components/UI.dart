import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/providers/AccessProvider.dart';
import 'package:proyecto_sgca_ebu/providers/Pesta%C3%B1aProvider.dart';
import 'package:proyecto_sgca_ebu/routes.dart';

class UIScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(context.watch<PestanaProvider>().textoDelAppBar)),
      ),
      body: Pestana(),
      bottomNavigationBar: _bottomAppBar(context),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.home, color: Colors.black),
          onPressed: () {
            context.read<PestanaProvider>().cambiarPagina(zona: 0, numPage: 0);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue,
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children:
            bottomAppBarContent(context, (context.watch<AccessProvider>().rol)),
      ),
    );
  }

  Column _item(Icon icon, Icon iconIfActive, String label, BuildContext context,
      List<int> infoPestana) {
    bool isActive = context.watch<PestanaProvider>().zonaID == infoPestana[0];

    TextStyle estiloTextoActivo = TextStyle(color: Colors.black, fontSize: 13);

    TextStyle estiloTextoInactivo =
        TextStyle(color: Colors.grey[300], fontSize: 13);

    TextStyle estiloAUsar =
        (isActive) ? estiloTextoActivo : estiloTextoInactivo;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: (!isActive) ? icon : iconIfActive,
            onPressed: () {
              if (!isActive) {
                context.read<PestanaProvider>().cambiarPagina(
                    zona: infoPestana[0], numPage: infoPestana[1]);
              }
            }),
        Text(label, style: estiloAUsar),
      ],
    );
  }

  List<Widget> bottomAppBarContent(BuildContext context, String rol) {
    if (rol == "admin") {
      return [
        Padding(padding: EdgeInsets.only(left: 5)),
        _item(
            Icon(Icons.face, color: Colors.grey[300], size: 32),
            Icon(Icons.face, color: Colors.black, size: 32),
            "Estudiantes",
            context,
            [1, 0]),
        _item(
            Icon(Icons.badge_outlined, color: Colors.grey[300], size: 32),
            Icon(Icons.badge_outlined, color: Colors.black, size: 32),
            "Docentes",
            context,
            [2, 0]),
        Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
        _item(
            Icon(Icons.school, color: Colors.grey[300], size: 32),
            Icon(Icons.school, color: Colors.black, size: 32),
            "Egresados",
            context,
            [3, 0]),
        _item(
            Icon(Icons.supervisor_account, color: Colors.grey[300], size: 32),
            Icon(Icons.supervisor_account, color: Colors.black, size: 32),
            "Representantes",
            context,
            [4, 0]),
        Padding(padding: EdgeInsets.only(right: 5)),
      ];
    } else {
      return [
        Padding(padding: EdgeInsets.only(left: 5)),
        _item(
            Icon(Icons.face, color: Colors.grey[300], size: 32),
            Icon(Icons.face, color: Colors.black, size: 32),
            "Estudiantes",
            context,
            [1, 0]),
        _item(
            Icon(Icons.supervisor_account, color: Colors.grey[300], size: 32),
            Icon(Icons.supervisor_account, color: Colors.black, size: 32),
            "Representantes",
            context,
            [4, 0]),
        Padding(padding: EdgeInsets.only(right: 5)),
      ];
    }
  }
}
