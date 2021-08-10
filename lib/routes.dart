import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/pages/Docentes/Docentes.dart';
import 'package:proyecto_sgca_ebu/pages/Egresados/Egresados.dart';
import 'package:proyecto_sgca_ebu/pages/Estudiantes/Estudiantes.dart';
import 'package:proyecto_sgca_ebu/pages/Principal.dart';
import 'package:proyecto_sgca_ebu/pages/Representantes/Representantes.dart';

Widget swapPage(int zonaId, int pestanaId) {
  switch (zonaId) {
    case 0:
      return Principal();
    case 1:
      return _swapPestanaEstudiantes(pestanaId);
    case 2:
      return _swapPestanaDocente(pestanaId);
    case 3:
      return _swapPestanaEgresados(pestanaId);
    case 4:
      return _swapPestanaRepresentantes(pestanaId);
    default:
      return Principal();
  }
}

Widget _swapPestanaDocente(int pestanaId) {
  switch (pestanaId) {
    case 0:
      return Docentes();
    default:
      return Docentes();
  }
}

Widget _swapPestanaEstudiantes(int pestanaId) {
  switch (pestanaId) {
    case 0:
      return Estudiantes();
    default:
      return Estudiantes();
  }
}

Widget _swapPestanaEgresados(int pestanaId) {
  switch (pestanaId) {
    case 0:
      return Egresados();
    default:
      return Egresados();
  }
}

Widget _swapPestanaRepresentantes(int pestanaId) {
  switch (pestanaId) {
    case 0:
      return Representantes();
    default:
      return Representantes();
  }
}
