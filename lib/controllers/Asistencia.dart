
import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/models/Asistencia.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _AsistenciaController {

  Future<void> eliminarAsistencias(int mes, int ambienteID, List<int> diasNoHabiles)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final results = await db.rawQuery(Asistencia.getAsistenciasPorAmbiente,[ambienteID,mes]);
    
    if(results.length == 0) return;
    
    for(var result in results){

      final asistenciaAModificar = Asistencia.fromMap(result);

      for(var diaNoHabil in diasNoHabiles){
        if(asistenciaAModificar.asistencias.contains(diaNoHabil) ){
          asistenciaAModificar.asistencias.remove(diaNoHabil);
        }
      }

      db.update(Asistencia.tableName,asistenciaAModificar.toJson(),where: 'id = ?',whereArgs:[asistenciaAModificar.id]);    
    }

  }

  Future<bool> existeAsistencia(int mes, int estudiante, [bool closeDB = true]) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Asistencia.tableName,where:'estudianteID = ? AND mes = ?',whereArgs:[estudiante,mes]);

    if(closeDB) db.close();

    return result.length != 0;
  }



  //POSIBLE UTILIZACION FUTURA
  Future<List<Map<String,Object?>>?> buscarAsistencias(int mes,int ambienteID,[bool enBaseAMatricula = false]) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final resultados = await db.rawQuery((enBaseAMatricula) ? Asistencia.getAsistenciasPorAmbienteEnBaseAMatricula: Asistencia.getAsistenciasPorAmbiente, (enBaseAMatricula) ? [mes,ambienteID] : [ambienteID,mes]);
    
    if(resultados.length == 0) return null;

    await db.close();

    return resultados;
  }
  
  Future<Asistencia?> buscarAsistencia(int mes,int estudiante) async {
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final resultados = await db.query(Asistencia.tableName,where:'estudianteID = ? AND mes = ?',whereArgs:[estudiante,mes]);
    
    if(resultados.length == 0) {
      db.close();
      return null;
    }
    
    db.close();
    return Asistencia.fromMap(resultados[0]);
  }

  

  Future<int> registrarAsistencia(Asistencia asistencia, [bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    int result;

    final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false);

    if(await existeAsistencia(asistencia.mes,asistencia.estudianteID,false)){
      //SI EXISTE LA ASISTENCIA, SOLO SE ACTUALIZARA
      result = await db.update(Asistencia.tableName,{...asistencia.toJson(),'añoEscolar':yearEscolar!.valor},where: 'id = ?',whereArgs:[asistencia.id!]);
    }else{
      //SI NO EXISTE LA ASISTENCIA, SOLO SE REGISTRARA
      result = await db.insert(Asistencia.tableName,{...asistencia.toJson(withId:false),'añoEscolar':yearEscolar!.valor});
    }

    if(closeDB) db.close();
    return result;
  }

  Future<List<int>> registrarMes(List<Asistencia> asistencias) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    List<Future<int>> consultas = [];
    
    for(var asistencia in asistencias){
      consultas.add(registrarAsistencia(asistencia,false));
    }

    if(db.isOpen) db.close();
    return await Future.wait(consultas);
  }

}

final controladorAsistencia = _AsistenciaController();