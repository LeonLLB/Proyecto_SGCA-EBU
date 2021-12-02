import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:proyecto_sgca_ebu/models/EgresadosRespaldo.dart';
import 'package:proyecto_sgca_ebu/models/Record.dart';
import 'package:proyecto_sgca_ebu/models/index.dart';
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

  Future<List<int>> graduar(String fechaGraduacion) async{
    final dbMain = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final dbBackup = await databaseFactoryFfi.openDatabase('sgca-ebu-database-egresados.db');
  
    final egresados = await dbMain.query(Egresado.getEgresadosActuales);
    
    String sqlWhere = 'WHERE ';

    for(var egresado in egresados){
      if(egresado == egresados[egresados.length-1]){
        sqlWhere = sqlWhere + ' estudianteID = ? ';
      }else{
        sqlWhere = sqlWhere + ' estudianteID = ? OR';
      }
    }
    
    final boletines = await dbMain.query(Record.tableName,where: sqlWhere, whereArgs:[egresados[0]['añoEscolarCursado'],...egresados.map((e)=>e['id']).toList()]);

    await dbMain.delete(Egresado.tableName);
    await dbMain.delete(Record.tableName,where:sqlWhere,whereArgs:[...egresados.map((e)=>e['id']).toList()]);

    await dbMain.close();

    List<int> retornable = [];

    for (var egresado in egresados) {
      final nuevoEgresado = EgresadoRespaldado(
        id: egresado['id'] as int,
        grado: egresado['grado'] as int,
        seccion: egresado['seccion'] as String,
        yearEscolarCursado: egresado['añoEscolarCursado'] as String,
        fechaGraduacion: fechaGraduacion,
        estudiante: {
          'nombres' : egresado['e.nombres'],
          'apellidos' : egresado['e.apellidos'],
          'cedula' : egresado['e.cedula'],
          'fecha_nacimiento' : egresado['e.fecha_nacimiento'],
          'genero' : egresado['e.genero'],
          'edad_al_graduarse' : calcularEdad(egresado['e.fecha_nacimiento']),
          'lugar_nacimiento' : egresado['e.lugar_nacimiento'],
          'estado_nacimiento' : egresado['e.estado_nacimiento']
        },
        representante: {
          'nombres' : egresado['r.nombres'],
          'apellidos' : egresado['r.apellidos'],
          'cedula' : egresado['r.cedula'],
        }
      );

      final resultEgresado = await dbBackup.insert(EgresadoRespaldado.tableName, nuevoEgresado.toJson());
      retornable.add(resultEgresado);
      final recordsDelEgresado = boletines.where((boletin) => boletin['estudianteID'] == egresado['id']);

      for(var records in recordsDelEgresado){
        final nuevoRecord = BoletinRespaldo(
          egresadoID: egresado['id'] as int,
          aprobado: (records['aprobado'] as int == 1),
          gradoCursado: records['gradoCursado'] as int,
          seccionCursada: records['seccionCursada'] as String,
          yearEscolar: records['añoEscolar'] as String,
          fechaInscripcion: records['fechaInscripcion'] as String
        );
        final result = await dbBackup.insert(BoletinRespaldo.tableName,nuevoRecord.toJson(false));
        retornable.add(result);
      }

    }
    await dbBackup.close();
    return retornable;
  }

}

final controladorEgresados = _EgresadosController();