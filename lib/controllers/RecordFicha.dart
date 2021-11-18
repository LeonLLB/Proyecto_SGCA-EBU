import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:proyecto_sgca_ebu/models/Ficha_Estudiante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/RecordFicha.dart';

class _RecordFichaController{

  Future<int> creacionInicialRecordFicha(FichaEstudiante fichaCreada,DateTime fechaNacimiento) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final yearEscolar = (await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false))!.valor;

    final nuevoRecord = RecordFicha(
      estudianteID: fichaCreada.estudianteID,
      talla: fichaCreada.talla,
      peso: fichaCreada.peso,
      edad: calcularEdad(fechaNacimiento),
      yearEscolar: yearEscolar
    );

    final result = await db.insert(RecordFicha.tableName,nuevoRecord.toJson(withId: false));

    return result;

  }

  Future<int> modificarFicha(FichaEstudiante fichaNueva, DateTime fechaNacimiento)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final yearEscolar = (await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false))!.valor;

    final nuevoRecordFicha = RecordFicha(
      id: fichaNueva.id,
      estudianteID: fichaNueva.estudianteID,
      talla: fichaNueva.talla,
      peso: fichaNueva.peso,
      edad: calcularEdad(fechaNacimiento),
      yearEscolar: yearEscolar
    );

    final result = db.update(RecordFicha.tableName,nuevoRecordFicha.toJson(),where:'id = ?',whereArgs:[fichaNueva.id]);

    db.close();

    return result;
  }

  Future<List<RecordFicha>?> obtenerRecords(int estudianteID) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final results = await db.query(RecordFicha.tableName,where:'estudianteID = ?',whereArgs: [estudianteID]);

    if(results.length == 0) return null;
    List<RecordFicha> retornable = [];
    for(var result in results){
      retornable.add(RecordFicha.fromMap(result));
    }

    db.close();

    return retornable;
  }

}

final controladorRecordFicha = _RecordFichaController();