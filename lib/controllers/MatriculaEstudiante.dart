import 'package:proyecto_sgca_ebu/models/Admin.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Estudiante.dart';

class _MatriculaEstudianteController{

  Future<Map<String,int>> contarEstudiantesEnGrados()async{
    Map<String,int> estudiantesPorGrado = {
      '1':0,
      '2':0,
      '3':0,
      '4':0,
      '5':0,
      '6':0,
      'TOTAL':0
    };

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final result = await db.rawQuery('SELECT am.grado FROM Ambientes am ORDER BY am.grado DESC LIMIT 1');

    final gradoMaximo = result[0]['grado'] as int;

    int sumaTotal = 0;
    
    for(var i = 1; i <= gradoMaximo; i++){
      estudiantesPorGrado[i.toString()] = (await db.rawQuery(MatriculaEstudiante.cantidadDeEstudiantesPorGrado,[i]))[0]['cantidadEstudiantes'] as int;
      sumaTotal += estudiantesPorGrado[i.toString()]!;
    }

    estudiantesPorGrado['TOTAL'] = sumaTotal;
    db.close();

    return estudiantesPorGrado;

  }

  Future<List<Map<String,Object?>>?> getMatricula(int? ambienteId)async{
    if(ambienteId == null) return null;
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final result = await db.rawQuery(MatriculaEstudiante.obtenerMatriculaCompleta,[ambienteId]);

    if(result.length == 0){
      db.close();
      return null;
    }

    List<Map<String,Object?>> resultadoNuevo = [];
    
    final cantidadEstudiantes = await db.query(MatriculaEstudiante.tableName,where:'ambienteID = ?',whereArgs: [ambienteId]);
    
    for (var index = 0; index < result.length; index++) {
      resultadoNuevo.add({
        ...result[index],
        'CantidadEstudiantes': cantidadEstudiantes.length
      });
    }

    db.close();
    return resultadoNuevo;
  }

  Future<int> registrar(int estudianteId, Ambiente ambiente) async {
    

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final int idMatriculaAsignable = ambiente.id!;

    final yearEscolar = await db.query(Admin.tableName,where:'opcion = ?',whereArgs:['AÑO_ESCOLAR']);

    final result = await db.insert(MatriculaEstudiante.tableName,{
      'ambienteID':idMatriculaAsignable,
      'estudianteID':estudianteId,
      'añoEscolar':yearEscolar[0]['valor']!
    });

    db.close();

    return result;

  }

}

final controladorMatriculaEstudiante = _MatriculaEstudianteController();