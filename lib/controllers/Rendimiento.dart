import 'package:proyecto_sgca_ebu/models/Rendimiento.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RendimientoController{

  Future<List<Rendimiento?>> buscarRendimientosSegunAmbiente(int ambienteID, [bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final resultados = await db.rawQuery(Rendimiento.obtenerRendimientosSegunMatriculaYAmbiente, [ambienteID]);

    if(closeDB){db.close();}

    List<Rendimiento?> results = [];

    for(var resultado in resultados){
      if (resultado['id'] != null) {
        results.add(Rendimiento.fromMap(resultado));
      }else{
        results.add(null);
      }
    }

    return results;
    
  }

  Future<Rendimiento?> buscarRendimiento(int matriculaID,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.query(Rendimiento.tableName, where: 'matricula_estudianteID = ?',whereArgs: [matriculaID]);

    if(closeDB){await db.close();}
    if(result.length == 0) return null;
    return Rendimiento.fromMap(result[0]);
  }

  Future<bool> existeRendimiento(int matriculaID, [bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.query(Rendimiento.tableName, where: 'matricula_estudianteID = ?',whereArgs: [matriculaID]);

    if(closeDB){db.close();}

    return result.length > 0;
    
  }

  Future<List<int>> registrarRendimientos(List<Rendimiento> rendimientos)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    List<Future<int>> listaDeTareas = [];
    for(var rendimiento in rendimientos){
      if(await existeRendimiento(rendimiento.matriculaEstudianteID,false)){
        listaDeTareas.add(db.update(Rendimiento.tableName,rendimiento.toJson(withId:false),where:'id = ?',whereArgs:[rendimiento.id]));
      }else{
        listaDeTareas.add(db.insert(Rendimiento.tableName,rendimiento.toJson(withId:false)));
      }
    }
    
    final results = await Future.wait(listaDeTareas);
    db.close();
    return results;
  }

}

final controladorRendimiento = _RendimientoController();