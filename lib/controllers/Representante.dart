import 'package:proyecto_sgca_ebu/models/Representante.dart';
import 'package:proyecto_sgca_ebu/models/index.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RepresentanteControllers{

  Future<int> registrar(Representante representante,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Representante.tableName,representante.toJson(withId: false));

    if(closeDB){db.close();}
    return result;
  }

  Future<int> actualizar(Representante representante,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.update(Representante.tableName,representante.toJson(),where:'id = ?',whereArgs:[representante.id]);

    if(closeDB){db.close();}
    return result;
  }

  Future<int> eliminar(int representanteID,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final confirmationResult = await db.query(EstudianteURepresentante.tableName,where:'representanteID = ?',whereArgs:[representanteID]);
    if(confirmationResult.length > 0) {if(closeDB){db.close();}return -1;} //ESTE REPRESENTANTE TIENE ESTUDIANTES, NO SE DEBE HACER EN ABSOLUTO NADA
    
    final result = await db.delete(Representante.tableName,where:'id = ?',whereArgs:[representanteID]);

    if(closeDB){db.close();}
    return result;
  }

  Future<Representante?> buscarRepresentante(int? cedula,[bool closeDB = true]) async {
    if(cedula == null) return null;
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Representante.tableName,where: 'cedula = ?',whereArgs: [cedula]);

    if(closeDB) {db.close();}
    return (result.isEmpty) ? null : Representante.fromMap(result[0]);
  }

  Future<List<Representante>?> buscarRepresentantes(int? cedula) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final resultados = await db.query(Representante.tableName,where: 'CAST(cedula AS TEXT) LIKE ?',whereArgs: ['%${cedula == null ? "" : cedula}%']);
    if(resultados.length == 0) return null;
    List<Representante> result = [];

    for(var representante in resultados){
      result.add(Representante.fromMap(representante));
    }

    db.close();
    return result;
  }

  Future<List<Map<String,Object?>>?> getRepresentanteYEstudiantes(int? cedula)async{
    if(cedula == null) return null;
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final results = await db.rawQuery(Representante.getRepresentanteAndEstudiantes,[cedula]);

    if(results.length == 0) return null;

    db.close();

    return results;
  }

}

final controladorRepresentante = _RepresentanteControllers();
