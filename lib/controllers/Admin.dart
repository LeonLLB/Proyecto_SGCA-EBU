import 'package:proyecto_sgca_ebu/controllers/Egresados.dart';
import 'package:proyecto_sgca_ebu/controllers/FichaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Record.dart';
import 'package:proyecto_sgca_ebu/models/Admin.dart';
import 'package:proyecto_sgca_ebu/models/Egresados.dart';
import 'package:proyecto_sgca_ebu/models/Estadistica.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Docente.dart';
import 'package:proyecto_sgca_ebu/models/Rendimiento.dart';
import 'package:proyecto_sgca_ebu/models/Asistencia.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _AdminController{

  Future<int> registrarOpcion(Admin opcion)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final result = await db.insert(Admin.tableName,opcion.toJson(withId:false));

    db.close();

    return result;
  }

  Future<int> actualizarOpcion(String opcionACambiar,Admin opcionActualizada)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    if(opcionACambiar == 'AÑO_ESCOLAR'){
      //PASO 1: REGISTRAR BOLETINES
      //PASO 2: CAMBIAR ESTADO DE REPITIENTE O REGULAR, SEGUN RENDIMIENTO
      await controladorRecord.registrarRecords(false);
    }

    
    if(opcionACambiar == 'AÑO_ESCOLAR'){
      //PASO 3: ELIMINAR TODA LA INFORMACIÓN DE LAS MATRICULAS, RENDIMIENTO Y ASISTENCIA
      await db.delete(MatriculaEstudiante.tableName);
      await db.delete(MatriculaDocente.tableName);
      await db.delete(Rendimiento.tableName);
      await db.delete(Asistencia.tableName);
      await db.delete(Estadistica.tableName);

      //PASO 4: SI EXISTEN ESTUDIANTES DE 6TO GRADO APROBADOS, MIGRARLOS A EGRESADOS Y
      //ELIMINAR SU FICHA DE INSCRIPCIÓN 

      final estudiantesAEgresar = await db.rawQuery(Egresado.consultarPosiblesEgresados);

      if(estudiantesAEgresar.length > 0){
        List<Egresado> nuevosEgresados = [];
        for(var estudiante in estudiantesAEgresar){
          nuevosEgresados.add(Egresado.fromMap(estudiante));
          await controladorFichaEstudiante.eliminarFicha(estudiante['estudianteID'] as int,false);
        }
        await controladorEgresados.egresar(nuevosEgresados,false);
      }    
    }
    
    final result = await db.update(Admin.tableName, opcionActualizada.toJson(withId:true),where: 'opcion = ?',whereArgs:[opcionACambiar] ); //(Admin.tableName,opcion.toJson(withId:false));
    
    db.close();

    return result;
  }

  Future<List<Admin>?> obtenerOpciones()async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final opciones = await db.query(Admin.tableName);
    List<Admin> results = [];

    for(var opcion in opciones){
      Admin adminOPT = Admin.fromMap(opcion);
      results.add(adminOPT);
    }

    db.close();

    return (results.length == 0 ) ? null : results;
  }

  Future<Admin?> obtenerOpcion(String opcion,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final opcionSolicitada = await db.query(Admin.tableName,where: 'opcion = ?',whereArgs:[opcion]);

    if(closeDB){db.close();}

    return (opcionSolicitada.length == 0) ? null : Admin.fromMap(opcionSolicitada[0]);
  }

}

final controladorAdmin = _AdminController();