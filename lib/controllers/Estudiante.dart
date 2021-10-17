import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante_U_Representante.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _EstudianteControllers{

  
Future<int> calcularCedulaEscolar ({int? inscripcionYear ,required int cedulaRepresentante})async{
  int anoInscripcion = (inscripcionYear == null) ? (DateTime.now().year - 2000) : inscripcionYear - 2000;

  final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
  final result = await db.query(Estudiante.tableName,where: 'CAST(cedula AS TEXT) LIKE ?',whereArgs: ['%$cedulaRepresentante$anoInscripcion']);

  return int.parse('${result.length + 1}$cedulaRepresentante$anoInscripcion');
}


  Future<int> registrar(Estudiante estudiante,{int? cedulaRepresentante,Representante? representante}) async{
    assert(cedulaRepresentante == null && representante != null,'Haz enviado la cedula y el representante, solo debes mandar unos de ellos');
    assert(cedulaRepresentante != null && representante == null,'Haz enviado la cedula y el representante, solo debes mandar unos de ellos');
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    if(cedulaRepresentante != null){
      final representanteCedula = await controladorRepresentante.buscarRepresentante(cedulaRepresentante);
      if(representanteCedula == null) return -1; // NO EXISTE EL REPRESENTANTE
      
      final resultEstudiante = await db.insert(Estudiante.tableName,estudiante.toJson(withId: false));
      
      await db.insert(EstudianteURepresentante.tableName, {'EstudianteID':resultEstudiante,'RepresentanteID':representanteCedula.id});
      db.close();
      return resultEstudiante;
    }else if(representante != null){
      final representanteInsertado = await controladorRepresentante.registrar(representante);
      final resultEstudiante = await db.insert(Estudiante.tableName,estudiante.toJson(withId: false));
      await db.insert(EstudianteURepresentante.tableName, {'EstudianteID':resultEstudiante,'RepresentanteID':representanteInsertado});
      db.close();
      return resultEstudiante;
    }
    return 0;
    
  }

}

final controladorEstudiante = _EstudianteControllers();
