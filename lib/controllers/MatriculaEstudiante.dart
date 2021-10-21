import 'package:proyecto_sgca_ebu/models/Admin.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Estudiante.dart';

class _MatriculaEstudianteController{

  Future<int> registrar(int estudianteId, int gradoDeseado) async {
    //PASO 2: PREPARAR LA CONSULTA PARA ENCONTRAR MATRICULAS CON AMBIENTES
    String consulta = "";
    List<Ambiente>? ambientes = await controladorAmbientes.buscarAmbientesPorGrado(gradoDeseado);

    if(ambientes == null) return -3; // NO HAY GRADO DESEADO

    for(var ambiente in ambientes){
      if(ambientes[ambientes.length -1] == ambiente){
        consulta = consulta + " ambienteID = ?;";
      }else{
        consulta = consulta + " ambienteID = ? OR";
      }
    }

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final resultadosMatriculas = await db.query(MatriculaEstudiante.tableName,where: consulta,whereArgs: ambientes.map((ambiente)=>ambiente.id).toList());
    // PASO 3: ENCONTRAR UN AMBIENTE DISPOSIBLE

    int idMatriculaAsignable = 0;

    for(var ambiente in ambientes){
      int contador = resultadosMatriculas
        .where((matricula) => matricula['ambienteID'] == ambiente.id)
        .toList().length;
      //SUPONGAMOS QUE LA CANTIDAD MAX DE ALUMNOS POR SALON ES DE 40
      if(contador <= 40){
        idMatriculaAsignable = ambiente.id!;
        break;
      }
      if(ambientes[ambientes.length - 1] == ambiente && idMatriculaAsignable == 0){
        return -2; // NO HAY MATRICULAS ASIGNABLES, INTENTE EL PROXIMO AÑO, O SE PUDIERA CAMBIAR EL MAX
      }
    }
    //PASO 4: INSERTAR EL ESTUDIANTE A UN AMBIENTE EN LA MATRICULA

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