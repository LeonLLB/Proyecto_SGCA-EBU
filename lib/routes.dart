import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/pages/index.dart';

final Map<String, Widget> _routes = {
  '/login':LoginPage(),
  '/registrar':RegisterPage(),
  '/home':HomeMenu(),
};

Route toPage (String pageName){

  assert(_routes[pageName] != null, "La ruta solicitada ($pageName) no existe");

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _routes[pageName]!,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      final curvedAnimation = CurvedAnimation(parent:animation,curve:Curves.easeInOut);
     
      if (Platform.isAndroid || Platform.isIOS) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0.0, -1.0),end: Offset.zero).animate(curvedAnimation),
          child: child,
        );
      }
      else{
        return FadeTransition(
          opacity: Tween<double>(begin:0.0,end:1.0).animate(curvedAnimation),
          child:child
        );
      }
    });
}
