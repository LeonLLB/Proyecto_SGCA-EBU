import 'package:proyecto_sgca_ebu/models/Representante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RepresentanteControllers{

  Future<int> registrar(Representante representante,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Representante.tableName,representante.toJson(withId: false));

    if(closeDB){db.close();}
    return result;
  }

  Future<Representante?> buscarRepresentante(int cedula,[bool closeDB = true]) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Representante.tableName,where: 'cedula = ?',whereArgs: [cedula]);

    if(closeDB) {db.close();}
    return (result.isEmpty) ? null : Representante.fromMap(result[0]);
  }

}

final controladorRepresentante = _RepresentanteControllers();
