import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Docente.dart';

class _MatriculaDocenteController{

  Future<bool> existeMatricula(int gradoDeseado, String seccionDeseada,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.rawQuery(MatriculaDocente.buscarExistenciaMatricula,[gradoDeseado,seccionDeseada, await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR')]);
    if(closeDB){db.close();}
    return (result.length > 0);
  }

  Future<Map<String,Object?>?> buscar(int cedulaDocente,[bool closeDB = true])async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.rawQuery(MatriculaDocente.fullSearch,[cedulaDocente]);
    if(closeDB){db.close();}
    return (result.length == 0) ? null : result[0];
  }

  Future<MatriculaDocente?> buscarPorGrado(int gradoDeseado, String seccionDeseada,[bool closeDB = true])async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final ambiente = await controladorAmbientes.obtenerAmbiente(gradoDeseado, seccionDeseada);

    final result = await db.query(MatriculaDocente.tableName,where:'ambienteID = ?',whereArgs: [ambiente!.id]);
    if(closeDB){db.close();}
    return (result.length == 0) ? null : MatriculaDocente.fromMap(result[0]);
  }

  Future<int> registrar(int cedulaDocente, int gradoDeseado, String seccionDeseada) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    //CASO 1: EL AMBIENTE NO TIENE ASIGNADO UN DOCENTE    
    if(await this.existeMatricula(gradoDeseado, seccionDeseada,false) == false){
      final docente = await controladorUsuario.buscarDocente(cedulaDocente);
      final ambiente = await controladorAmbientes.obtenerAmbiente(gradoDeseado, seccionDeseada);
      final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');
      
      final matriculaNueva = MatriculaDocente(ambienteID: ambiente!.id!,docenteID:docente!.id!,yearEscolar: yearEscolar!.opcion);
      
      final result = await db.insert(MatriculaDocente.tableName, matriculaNueva.toJson(withId:false));
      db.close();
      return result;
    }
    //CASO 2: EL AMBIENTE YA TIENE ASIGNADO A UN DOCENTE
    else if(await this.existeMatricula(gradoDeseado, seccionDeseada,false)){
      final docente = await controladorUsuario.buscarDocente(cedulaDocente);
      final ambiente = await controladorAmbientes.obtenerAmbiente(gradoDeseado, seccionDeseada);
      final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');
      
      final matriculaVieja = await this.buscarPorGrado(gradoDeseado, seccionDeseada,false);
      final matriculaNueva = MatriculaDocente(id:matriculaVieja!.id,ambienteID: ambiente!.id!,docenteID:docente!.id!,yearEscolar: yearEscolar!.opcion);
      
      final result = await db.update(MatriculaDocente.tableName,matriculaNueva.toJson(),where:'id = ?',whereArgs:[matriculaVieja.id]);
      db.close();
      return result;
    }
    //CASE 3: EL DOCENTE YA ESTA ASIGNADO, Y EL AMBIENTE NO TIENE DOCENTE
    else if(
      (await this.buscar(cedulaDocente,false)) != null &&
      (await this.existeMatricula(gradoDeseado, seccionDeseada,false)) == false )
    {

    }
    return 0;
  }

}

final controladorMatriculaDocente = _MatriculaDocenteController();