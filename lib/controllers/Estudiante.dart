import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante_U_Representante.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _EstudianteControllers{

  
Future<int> calcularCedulaEscolar ({int? inscripcionYear ,required int cedulaRepresentante})async{
  int anoInscripcion = (inscripcionYear == null) ? (DateTime.now().year - 2000) : inscripcionYear - 2000;

  final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
  final result = await db.query(Estudiante.tableName,where: 'CAST(cedula AS TEXT) LIKE ?',whereArgs: ['%$anoInscripcion$cedulaRepresentante']);

  return int.parse('${result.length + 1}$anoInscripcion$cedulaRepresentante');
}


  Future<int> registrar(Estudiante estudiante,{int? cedulaRepresentante,Representante? representante,required int gradoDeseado}) async{
      
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    if(cedulaRepresentante != null){
      final representanteCedula = await controladorRepresentante.buscarRepresentante(cedulaRepresentante,false);
      if(representanteCedula == null) return -1; // NO EXISTE EL REPRESENTANTE
      
      int resultEstudiante = await db.insert(Estudiante.tableName,estudiante.toJson(withId: false));
      
      if(resultEstudiante != 0){
        await db.insert(EstudianteURepresentante.tableName, {'EstudianteID':resultEstudiante,'RepresentanteID':representanteCedula.id});
        resultEstudiante = await controladorMatriculaEstudiante.registrar(resultEstudiante, gradoDeseado);        
      }

      return resultEstudiante;

    }else if(representante != null){

      if(await controladorRepresentante.buscarRepresentante(representante.cedula) != null) return -1;

      final representanteInsertado = await controladorRepresentante.registrar(representante);
      int resultEstudiante = await db.insert(Estudiante.tableName,estudiante.toJson(withId: false));
      
      if(resultEstudiante != 0){
        await db.insert(EstudianteURepresentante.tableName, {'EstudianteID':resultEstudiante,'RepresentanteID':representanteInsertado});
        resultEstudiante = await controladorMatriculaEstudiante.registrar(resultEstudiante, gradoDeseado);
      }
      db.close();
      return resultEstudiante;
    }
    return 0;
    
  }

}

final controladorEstudiante = _EstudianteControllers();
