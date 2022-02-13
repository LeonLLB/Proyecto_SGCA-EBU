import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/pages/index.dart';

final Map<String, Widget> routes = {
  '/login'                      :LoginPage(),
  '/registrar'                  :RegisterPage(),
  '/home'                       :HomeMenu(),
  '-estudiantes'                :EstudiantesMenu(),
  '-docentes'                   :DocentesMenu(),
  '-representantes'             :RepresentantesMenu(),
  '-egresados'                  :EgresadosMenu(),
  '-admin'                      :AdminMenu(),

  '-estudiantes/inscribir'      :InscribirEstudiante(),
  '-estudiantes/fichaestudiante':FichaEstudiantePage(),
  '-estudiantes/buscar'         :BuscarEstudiante(),
  '-estudiantes/estadistica'    :EstadisticaEstudiante(),
  '-estudiantes/asistencia'     :SubirAsistenciaEstudiante(),
  '-estudiantes/rendimiento'    :SubirRendimientoEstudiante(),
  '-estudiantes/matricula'      :MatriculaEstudiante(),
  '-estudiantes/constancia'     :EstudianteGenerarConstancia(),
  '-estudiantes/retiro'         :RetiroEstudiante(),

  '-docentes/inscribir'         :InscribirDocente(),
  '-docentes/actualizar'        :ActualizarDocente(),
  '-docentes/buscar'            :BuscarDocente(),
  '-docentes/matricula'         :MatriculaDocente(),
  '-docentes/asignar'           :AsignarDocente(),

  '-representantes/inscribir'   :InscribirRepresentante(),
  '-representantes/actualizar'  :ActualizarRepresentante(),
  '-representantes/buscar'      :BuscarRepresentante(),
  '-representantes/visualizar'  :VisualizarRepresentante(),

  '-egresados/nuevos'           :EgresadosNuevos(),
  '-egresados/consulta'         :EgresadosConsulta(),

  '-admin/inscribirgrado'       :AdminInscribirGrado(),
  '-admin/vergrados'            :AdminVerGrado(),
  '-admin/gestiongrado'         :GestionarGrado(),
  '-admin/cambiarañoescolar'    :AdminCambiarYearEscolar(),
  '-admin/inscribiradmin'       :InscribirAdministrador(),
  '-admin/gestionaradmin'       :GestionarAdministrador(),
};

Route toPage (String pageName){

  assert(routes[pageName] != null, "La ruta solicitada ($pageName) no existe");
  assert(pageName.startsWith('/'),'La ruta $pageName no es valida,quiza sea solamente utilizable de manera interna');

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => routes[pageName]!,
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
