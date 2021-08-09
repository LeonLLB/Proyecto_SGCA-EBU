import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/pages/Docentes.dart';
import 'package:proyecto_sgca_ebu/pages/Egresados.dart';
import 'package:proyecto_sgca_ebu/pages/Estudiantes.dart';
import 'package:proyecto_sgca_ebu/pages/Principal.dart';
import 'package:proyecto_sgca_ebu/pages/Representantes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGCA-EBU',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Principal(),
        '/estudiantes': (context) => Estudiantes(),
        '/docentes': (context) => Docentes(),
        '/egresados': (context) => Egresados(),
        '/representantes': (context) => Representantes(),
      },
    );
  }
}
