import 'package:flutter/material.dart';

class UIScaffold extends StatelessWidget {
  final Widget body;
  final String appBarText;
  final String rol = "admin";
  UIScaffold({required this.body, this.appBarText = "SGCA - EBU"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(this.appBarText)),
      ),
      body: this.body,
      bottomNavigationBar: _bottomAppBar(context),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName("/"));
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
        children: bottomAppBarContent(context, (rol == "admin")),
      ),
    );
  }

  Column _item(Icon icon, Text label, String route, BuildContext context) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: icon,
              onPressed: () {
                if (ModalRoute.of(context)!.settings.name != route) {
                  Navigator.pushNamed(context, route, arguments: {'rol': rol});
                }
              }),
          label
        ],
      );
  List<Widget> bottomAppBarContent(BuildContext context, bool esAdmin) {
    if (esAdmin) {
      return [
        Padding(padding: EdgeInsets.only(left: 5)),
        _item(
            Icon(Icons.face, color: Colors.grey[300], size: 32),
            Text("Estudiantes",
                style: TextStyle(color: Colors.grey[300], fontSize: 13)),
            "/estudiantes",
            context),
        _item(
            Icon(Icons.badge_outlined, color: Colors.grey[300], size: 32),
            Text("Docentes",
                style: TextStyle(color: Colors.grey[300], fontSize: 13)),
            "/docentes",
            context),
        Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
        _item(
            Icon(Icons.school, color: Colors.grey[300], size: 32),
            Text("Egresados",
                style: TextStyle(color: Colors.grey[300], fontSize: 13)),
            "/egresados",
            context),
        _item(
            Icon(Icons.supervisor_account, color: Colors.grey[300], size: 32),
            Text("Representantes",
                style: TextStyle(color: Colors.grey[300], fontSize: 13)),
            "/representantes",
            context),
        Padding(padding: EdgeInsets.only(right: 5)),
      ];
    } else {
      return [
        Padding(padding: EdgeInsets.only(left: 5)),
        _item(
            Icon(Icons.face, color: Colors.grey[300], size: 32),
            Text("Estudiantes",
                style: TextStyle(color: Colors.grey[300], fontSize: 13)),
            "/estudiantes",
            context),
        _item(
            Icon(Icons.supervisor_account, color: Colors.grey[300], size: 32),
            Text("Representantes",
                style: TextStyle(color: Colors.grey[300], fontSize: 13)),
            "/representantes",
            context),
        Padding(padding: EdgeInsets.only(right: 5)),
      ];
    }
  }
}
