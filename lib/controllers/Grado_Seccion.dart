import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';

class _AmbientesController{

  Future<int> registrarAmbiente(Ambiente ambiente) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Ambiente.tableName,ambiente.toJson(withId:false));

    db.close();
    return result;

  }

  Future<List<Ambiente>?> buscarAmbientesPorGrado(int grado) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Ambiente.tableName,orderBy: 'seccion DESC',where: 'grado = ?',whereArgs: [grado]);

    db.close();    
    List<Ambiente> listaDeAmbientes = [];

    for(var ambiente in result){
      listaDeAmbientes.add(Ambiente.fromMap(ambiente));
    }
        
    return (listaDeAmbientes.length == 0 ) ? null : listaDeAmbientes;
  }

  Future<List<Ambiente>?> obtenerGrados()async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Ambiente.tableName,orderBy: 'grado, seccion');
    
    db.close();    
    List<Ambiente> listaDeAmbientes = [];

    for(var ambiente in result){
      listaDeAmbientes.add(Ambiente.fromMap(ambiente));
    }
    
    return (listaDeAmbientes.length == 0 ) ? null : listaDeAmbientes;
  }

}

final controladorAmbientes = _AmbientesController();