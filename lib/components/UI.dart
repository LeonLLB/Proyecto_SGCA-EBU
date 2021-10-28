import 'package:flutter/material.dart';

class UI extends StatelessWidget {
  final Widget child;

  UI({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff96BAFF),
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
          )),
          title: Center(
              child: Text(
            'Sistema de Gestión y Control Académico : Escuela Basica Uriapara',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          )),
        ),
        body: child);
  }
}
