import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/pages/Estudiantes/Estudiantes.dart';
import 'package:proyecto_sgca_ebu/pages/Estudiantes/Inscribir.dart';
import 'package:proyecto_sgca_ebu/pages/Docentes/Docentes.dart';
import 'package:proyecto_sgca_ebu/pages/Egresados/Egresados.dart';
import 'package:proyecto_sgca_ebu/pages/Principal.dart';
import 'package:proyecto_sgca_ebu/pages/Representantes/Inscribir.dart';
import 'package:proyecto_sgca_ebu/pages/Representantes/Representantes.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/providers/Pesta%C3%B1aProvider.dart';

class Pestana extends StatefulWidget {
  Pestana({Key? key}) : super(key: key);

  @override
  _PestanaState createState() => _PestanaState();
}

class _PestanaState extends State<Pestana> {
  double opacity = 0;

  void cambiarOpacity() {
    opacity = 0;
    setState(() {});
    Future.delayed(Duration(milliseconds: 300), () {
      opacity = 1;
      setState(() {});
    });
  }

  final List<List<Widget>> paginas = [
    [Principal()],
    [
      Estudiantes(),
      EstudianteInscribir(),
    ],
    [Docentes()],
    [Egresados()],
    [
      Representantes(),
      RepresentanteInscribir(),
    ]
  ];

  @override
  void didUpdateWidget(covariant Pestana oldWidget) {
    super.didUpdateWidget(oldWidget);
    cambiarOpacity();
  }

  @override
  void initState() {
    super.initState();
    cambiarOpacity();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 300),
        child: paginas[context.watch<PestanaProvider>().zonaID]
            [context.watch<PestanaProvider>().pestanaID]);
  }
}
