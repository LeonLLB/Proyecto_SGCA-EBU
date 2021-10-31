import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Docente.dart';

class _MatriculaDocenteController{

  Future<int> casoModificacionMatricula(int cedulaDocente, Ambiente ambiente,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final bool existeMatriculaDocente = await this.buscar(cedulaDocente,false) != null;
    final bool existeMatriculaGrado = await this.existeMatricula(ambiente,false);
    
    if(closeDB){db.close();}
    if(existeMatriculaDocente == false && existeMatriculaGrado == false) return 1;
    else if(existeMatriculaDocente == false && existeMatriculaGrado == true) return 2;
    else if(existeMatriculaDocente == true && existeMatriculaGrado == false) return 3;
    else if(existeMatriculaDocente == true && existeMatriculaGrado == true) return 4;
    else return 0;
    //CASO 1: EL AMBIENTE NO TIENE ASIGNADO UN DOCENTE Y EL DOCENTE NO TIENE ASIGNADO UN AMBIENTE
    
    //CASO 2: EL AMBIENTE YA TIENE ASIGNADO A UN DOCENTE Y EL DOCENTE NO TIENE ASIGNADO UN AMBIENTE
    
    //CASE 3: EL DOCENTE YA ESTA ASIGNADO, Y EL AMBIENTE NO TIENE DOCENTE
    
    //CASO 4: EL DOCENTE YA ESTA ASIGNADO, Y EL AMBIENTE TIENE DOCENTE
  }

  Future<bool> existeMatricula(Ambiente ambienteDeseado,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false);
    final result = await db.rawQuery(MatriculaDocente.buscarExistenciaMatricula,[yearEscolar!.valor,ambienteDeseado.id]);
    
    if(closeDB){db.close();}
    return (result.length > 0);
  }

  Future<Map<String,Object?>?> buscar(int cedulaDocente,[bool closeDB = true])async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.rawQuery(MatriculaDocente.fullSearch,[cedulaDocente]);
    if(closeDB){db.close();}
    return (result[0]['id'] == null) ? null : result[0];
  }

  Future<Map<String,Object?>?> buscarPorGrado(Ambiente? ambiente,[bool closeDB = true])async {
    if(ambiente == null) return null;
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.rawQuery(MatriculaDocente.fullSearchPorGrado,[ambiente.grado, ambiente.seccion]);
    if(closeDB){db.close();}
    return (result[0]['id'] == null) ? null : result[0];
  }

  Future<int> registrar(int cedulaDocente, Ambiente ambienteDeseado) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final docente = await controladorUsuario.buscarDocente(cedulaDocente,false);
    final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false);

    //CASO 1: EL AMBIENTE NO TIENE ASIGNADO UN DOCENTE Y EL DOCENTE NO TIENE ASIGNADO UN AMBIENTE
    
    //CASO 2: EL AMBIENTE YA TIENE ASIGNADO A UN DOCENTE Y EL DOCENTE NO TIENE ASIGNADO UN AMBIENTE
    
    //CASE 3: EL DOCENTE YA ESTA ASIGNADO, Y EL AMBIENTE NO TIENE DOCENTE
    
    //CASO 4: EL DOCENTE YA ESTA ASIGNADO, Y EL AMBIENTE TIENE DOCENTE

    switch (await casoModificacionMatricula(cedulaDocente, ambienteDeseado,false)) {
      
      case 1:
        final matriculaNueva = MatriculaDocente(ambienteID: ambienteDeseado.id!,docenteID:docente!.id!,yearEscolar: yearEscolar!.valor);
      
        final result = await db.insert(MatriculaDocente.tableName, matriculaNueva.toJson(withId:false));
        db.close();
        return result;

      case 2:
        final matriculaVieja = await this.buscarPorGrado(ambienteDeseado,false);
        final matriculaNueva = MatriculaDocente(id:matriculaVieja!['id'] as int,ambienteID: ambienteDeseado.id!,docenteID:docente!.id!,yearEscolar: yearEscolar!.valor);
        
        final result = await db.update(MatriculaDocente.tableName,matriculaNueva.toJson(),where:'id = ?',whereArgs:[matriculaVieja['id']]);
        db.close();
        return result;

      case 3:
        final matriculaVieja = await this.buscar(cedulaDocente,false);
        final matriculaNueva = MatriculaDocente(id:matriculaVieja!['id'] as int,ambienteID: ambienteDeseado.id!,docenteID:docente!.id!,yearEscolar: yearEscolar!.valor);

        final result = await db.update(MatriculaDocente.tableName,matriculaNueva.toJson(),where:'id = ?',whereArgs:[matriculaVieja['id']]);
        db.close();
        return result;

      case 4:
        final matriculaViejaDocente = await this.buscar(cedulaDocente,false);
        final matriculaViejaGrado = await this.buscarPorGrado(ambienteDeseado,false);
        final matriculaNueva = MatriculaDocente(id:matriculaViejaDocente!['id'] as int,ambienteID: ambienteDeseado.id!,docenteID:docente!.id!,yearEscolar: yearEscolar!.valor);
        
        await db.delete(MatriculaDocente.tableName,where:'id = ?',whereArgs: [matriculaViejaGrado!['id']]);
        final result = await db.update(MatriculaDocente.tableName,matriculaNueva.toJson(),where:'id = ?',whereArgs:[matriculaViejaDocente['id']]);
        db.close();
        return result;

      default:
        return -1;
    }

  }

}

final controladorMatriculaDocente = _MatriculaDocenteController();