import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/pages/index.dart';

final Map<String, Widget> _routes = {
  '/login':LoginPage(),
};

Route toPage (String pageName){

  assert(_routes[pageName] != null, "La ruta solicitada ($pageName) no existe");

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _routes[pageName]!,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      if (Platform.isAndroid || Platform.isIOS) {
        var animacion = Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.ease));

        return SlideTransition(
          position: animation.drive(animacion),
          child: child,
        );
      }
      else{
        var animacion = Tween(begin:0.0,end:1.0)
        .chain(CurveTween(curve: Curves.ease));

        return FadeTransition(
          opacity: animation.drive(animacion),
          child:child
        );
      }
    });
}
