import 'package:proyecto_sgca_ebu/models/Representante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RepresentanteControllers{

  Future<int> registrar(Representante representante) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Representante.tableName,representante.toJson(withId: false));

    db.close();
    return result;
  }

  Future<Representante?> buscarRepresentante(int cedula) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Representante.tableName,where: 'cedula = ?',whereArgs: [cedula]);

    db.close();
    return Representante.fromMap(result[0]);
  }

}

final controladorRepresentante = _RepresentanteControllers();
