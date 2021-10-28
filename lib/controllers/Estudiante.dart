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

  Future<List<Map<String,Object?>>> getEstudiantes(int? cedulaEscolar, int? cedulaRepresentante)async{
    String type = '';
    String consulta = '';
    
    // CASO 1: SE ENVIO LA CEDULA ESCOLAR SOLAMENTE
    if(cedulaEscolar != null && cedulaRepresentante == null){
      type = 'E';
      consulta = EstudianteURepresentante.consultarUnionEuRuMEuAM(cedulaEscolar, null, type);
    }
    
    // CASO 2: SE ENVIO LA CEDULA DEL REPRESENTANTE SOLAMENTE
    else if(cedulaEscolar == null && cedulaRepresentante != null){
      type = 'R';
      consulta = EstudianteURepresentante.consultarUnionEuRuMEuAM(cedulaRepresentante, null, type);
    }
    
    // CASO 3: SE ENVIO AMBAS CEDULAS
    else if(cedulaEscolar != null && cedulaRepresentante != null){
      type = 'ER';
      consulta = EstudianteURepresentante.consultarUnionEuRuMEuAM(cedulaEscolar,cedulaRepresentante, type);
    }
    //CASO 4: NO HAY CEDULA
    else{
      type = 'ALL';
      consulta = EstudianteURepresentante.consultarUnionEuRuMEuAM(null,null, type);
    }
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final results = await db.rawQuery(consulta);
    db.close();
    return results;
  }

  Future<Map<String,Object?>?> buscarEstudiante (int? cedulaEscolar) async{
    
    String consulta = EstudianteURepresentante.consultarUnionEuRuMEuAM(cedulaEscolar, null, 'E');

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.rawQuery(consulta);
    db.close();
    return (result.length == 0 ) ? null : result[0];
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

      if(await controladorRepresentante.buscarRepresentante(representante.cedula,false) != null) return -1;

      final representanteInsertado = await controladorRepresentante.registrar(representante,false);
      int resultEstudiante = await db.insert(Estudiante.tableName,estudiante.toJson(withId: false));
      
      if(resultEstudiante != 0){
        await db.insert(EstudianteURepresentante.tableName, {'EstudianteID':resultEstudiante,'RepresentanteID':representanteInsertado});
        resultEstudiante = await controladorMatriculaEstudiante.registrar(resultEstudiante, gradoDeseado);
      }
      if(db.isOpen){db.close();}
      return resultEstudiante;
    }
    return 0;
    
  }

}

final controladorEstudiante = _EstudianteControllers();
