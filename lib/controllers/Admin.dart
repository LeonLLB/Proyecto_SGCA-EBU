import 'package:proyecto_sgca_ebu/models/Admin.dart';
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

  Future<Admin?> obtenerOpcion(String opcion)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final opcionSolicitada = await db.query(Admin.tableName,where: 'opcion = ?',whereArgs:[opcion]);

    db.close();

    return (opcionSolicitada.length == 0) ? null : Admin.fromMap(opcionSolicitada[0]);
  }

}

final controladorAdmin = _AdminController();