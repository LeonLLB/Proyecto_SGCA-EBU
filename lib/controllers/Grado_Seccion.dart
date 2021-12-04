import 'package:proyecto_sgca_ebu/models/Matricula_Estudiante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';

class _AmbientesController{

  Future<List<Ambiente>> obtenerListadoDeAmbientesSegunAmbiente(int ambienteID,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final results = await db.rawQuery(Ambiente.getAmbientesPorAmbiente,[ambienteID]);

    if(closeDB){db.close();}

    return results.map((result)=>Ambiente.fromMap(result)).toList();

  }

  Future<int> registrarAmbiente(Ambiente ambiente) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Ambiente.tableName,ambiente.toJson(withId:false));

    db.close();
    return result;

  }

  Future<List<Map<String,Object?>>?> obtenerAmbientesConEstudiantes(int? grado) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    List<Map<String,Object?>>? results;

    if(grado != null){
      results = await db.query(Ambiente.tableName,where:'grado = ?',whereArgs:[grado]);
      if(results.length == 0) return null;
    }else{
      results = await db.query(Ambiente.tableName,orderBy:'grado,seccion');
      if(results.length == 0) return null;
    }
    

    final cantidadEstudiantesAmbienteFutures = results.map((result)async{
      final cantidad = await db.rawQuery(MatriculaEstudiante.cantidadDeEstudiantes,[result['id']]);
      return cantidad[0]['cantidadEstudiantes'] as int;
    }).toList();

    List<int> cantidadEstudiantesAmbiente = await Future.wait(cantidadEstudiantesAmbienteFutures);

    db.close();

    List<Map<String,Object?>> resultadoNuevo = [];

    for (var i = 0; i < results.length; i++) {
      resultadoNuevo.add({
        ...results[i],
        'cantidadEstudiantes': cantidadEstudiantesAmbiente[i]
      });
    }

    return resultadoNuevo;
  }

  Future<Ambiente?> obtenerAmbiente(int grado, String seccion, [bool closeDB = true]) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Ambiente.tableName,where:'grado = ? AND seccion = ?',whereArgs:[grado,seccion]);

    if(closeDB){db.close();}

    return (result.length == 0) ? null : Ambiente.fromMap(result[0]);

  }

  

  Future<List<Ambiente>?> buscarAmbientesPorGrado(int grado) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Ambiente.tableName,orderBy: 'seccion ASC',where: 'grado = ?',whereArgs: [grado]);

    db.close();    
    List<Ambiente> listaDeAmbientes = [];

    for(var ambiente in result){
      listaDeAmbientes.add(Ambiente.fromMap(ambiente));
    }
        
    return (listaDeAmbientes.length == 0 ) ? null : listaDeAmbientes;
  }

  Future<Ambiente?> obtenerAmbientePorID(int id,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Ambiente.tableName,where:'id = ?',whereArgs:[id]);

    if(closeDB){db.close();}

    if(result.length == 0) return null;

    return Ambiente.fromMap(result[0]);
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