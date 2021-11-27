import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Egresados.dart';

class _EgresadosController{

  Future<List<int>> egresar(List<Egresado> nuevosEgresados,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    List<int> retornable = [];

    for(var egresado in nuevosEgresados){
      retornable.add((await db.insert(Egresado.tableName,egresado.toJson(false))));
    }
    
    if(closeDB){db.close();}

    return retornable;

  }

  Future<List<Map<String,Object?>>?> getEgresadosActuales() async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.rawQuery(Egresado.getEgresadosActuales);
    if(result.length == 0){
      db.close();
      return null;
    }
    return result;
  }

}

final controladorEgresados = _EgresadosController();