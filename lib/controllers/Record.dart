import 'package:proyecto_sgca_ebu/models/Record.dart';
import 'package:proyecto_sgca_ebu/models/BoletinRespaldo.dart';
import 'package:proyecto_sgca_ebu/models/Ficha_Estudiante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _RecordController{

  Future<void> registrarRecords([bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final data = await db.rawQuery(Record.getData);

    for(var info in data){
      await db.insert(Record.tableName, {...info,'aprobado':(info['aprobado'] != null) ? info['aprobado'] : 0});
      await db.update(FichaEstudiante.tableName,{'tipo_estudiante':(info['aprobado'] != null && info['aprobado'] == 1) ? 'Regular' : 'Repitiente'},where:'estudianteID = ?',whereArgs:[info['estudianteID']]);
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

    final result = await db.query(Record.tableName,where:'estudianteID = ?',orderBy:'añoEscolar DESC',whereArgs: [estudianteID],limit:1);

    if(closeDB){db.close();}

    if(result.length == 0) return null;
    
    return Record.fromMap(result[0]);
  }

  Future<List<BoletinRespaldo>?> obtenerRecordsDeEgresadoR(int egresadoID,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database-egresados.db');

    final results = await db.query(BoletinRespaldo.tableName,where:'egresadoID = ?',whereArgs: [egresadoID]);

    if(results.length == 0) return null;
    List<BoletinRespaldo> retornable = [];
    for(var result in results){
      retornable.add(BoletinRespaldo.fromMap(result));
    }

    if(closeDB){db.close();}

    return retornable;

  }

}

final controladorRecord = _RecordController();