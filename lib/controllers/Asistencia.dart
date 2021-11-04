import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/models/Asistencia.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _AsistenciaController {

  Future<bool> existeAsistencia(int mes, int estudiante, int nSemana, [bool closeDB = true]) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Asistencia.tableName,where:'estudianteID = ? AND mes = ? AND numero_semana = ?',whereArgs:[estudiante,mes,nSemana]);

    if(closeDB) db.close();

    return result.length != 0;
  }

  Future<List<Asistencia>?> buscarAsistencias(int mes) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final resultados = await db.query(Asistencia.tableName);
    if(resultados.length == 0) return null;
    List<Asistencia> result = [];
    for(var resultado in resultados){
      result.add(Asistencia.fromMap(resultado));
    }
    db.close();
    return result;
  }

  Future<Asistencia?> buscarAsistencia(int mes,int estudiante, int nSemana) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final resultados = await db.query(Asistencia.tableName,where:'estudianteID = ? AND mes = ? AND numero_semana = ?',whereArgs:[estudiante,mes,nSemana]);
    if(resultados.length == 0) {
      db.close();
      return null;
    }
    
    db.close();
    return Asistencia.fromMap(resultados[0]);
  }

  

  Future<int> registrarSemana(Asistencia asistencia, [bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    int result;

    final yearEscolar = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');

    if(await existeAsistencia(asistencia.mes,asistencia.estudianteID, asistencia.numeroSemana,false)){
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
      consultas.add(registrarSemana(asistencia));
    }

    if(db.isOpen) db.close();
    return await Future.wait(consultas);
  }

}

final controladorAsistencia = _AsistenciaController();