import 'package:intl/intl.dart';
import 'package:proyecto_sgca_ebu/controllers/RecordFicha.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Ficha_Estudiante.dart';

class _FichaEstudianteController{

  Future<Map<String,Object?>?> getFichaCompleta(int? cedulaEscolar)async{
    if(cedulaEscolar == null) return null;
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final result = await db.rawQuery(FichaEstudiante.getFichaCompleta,[cedulaEscolar]);
    
    await db.close(); 
    if(result.length == 0) return null;
    return result[0];   
  }

  Future<int> creacionFichaInicial(int estudianteID, String tipoEstudiante, DateTime fechaDeInscripcion,String procedencia,DateTime fechaNacimiento,[bool closeDB = true])async{
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final fechaInscripcion = DateFormat('d/M/y').format(fechaDeInscripcion);
    
    final fichaEstudianteNueva = FichaEstudiante(
      estudianteID: estudianteID,
      tipoEstudiante: tipoEstudiante,
      fechaInscripcion: fechaInscripcion,
      procedencia: procedencia,
      talla: 0.0,
      peso: 0.0,
      alergia: false,
      asma: false,
      cardiaco: false,
      tipaje: false,
      respiratorio: false,
      detalles: ''
    );

    final result = await db.insert(FichaEstudiante.tableName,fichaEstudianteNueva.toJson(withId:false));
    await controladorRecordFicha.creacionInicialRecordFicha(fichaEstudianteNueva,fechaNacimiento);
    if(closeDB){db.close();}

    return result;
  }

  Future<int> actualizarFicha(FichaEstudiante nuevaFicha,DateTime fechaNacimiento)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = db.update(FichaEstudiante.tableName,nuevaFicha.toJson(),where:'id = ?',whereArgs:[nuevaFicha.id]);
    await controladorRecordFicha.modificarFicha(nuevaFicha,fechaNacimiento);
    db.close();

    return result;
  }

  Future<int> eliminarFicha(int estudianteID,[bool closeDB = true]) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.delete(FichaEstudiante.tableName,where:'estudianteID = ?',whereArgs:[estudianteID]);

    if(closeDB){db.close();}

    return result;
  }

}

final controladorFichaEstudiante = _FichaEstudianteController();