import 'package:proyecto_sgca_ebu/models/index.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RecordController{

  Future<void> registrarRecords([bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final data = await db.rawQuery(Record.getData);

    for(var info in data){
      await db.insert(Record.tableName, info);
    }

    if(closeDB)db.close();
  }

  Future<List<Record>?> obtenerRecordsDeEstudiante(int estudianteID,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final results = await db.query(Record.tableName,where:'estudianteID = ?',whereArgs: [estudianteID]);

    if(results.length == 0) return null;
    List<Record> retornable = [];
    for(var result in results){
      retornable.add(Record.fromMap(result));
    }

    if(closeDB){db.close();}

    return retornable;

  }

  Future<Record?> obtenerUltimoRecord(int estudianteID,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Record.tableName,where:'estudianteID = ?',whereArgs: [estudianteID],orderBy: 'añoEscolar DESC',limit:1);

    if(closeDB){db.close();}

    if(result.length == 0) return null;

    return Record.fromMap(result[0]);
  }

}

final controladorRecord = _RecordController();