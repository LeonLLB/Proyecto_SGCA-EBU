import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/controllers/Estadistica.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/controllers/Record.dart';
import 'package:proyecto_sgca_ebu/models/Admin.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Estudiante.dart';

class _MatriculaEstudianteController{

  Future<Map<String,int>> contarEstudiantes(List<Ambiente> listadoAmbientes)async{
    Map<String,int> retornable = {};
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    for(var ambiente in listadoAmbientes){
      retornable['${ambiente.grado}${ambiente.seccion}'] = (await db.rawQuery(MatriculaEstudiante.cantidadDeEstudiantesPorAmbiente,[ambiente.id]))[0]['cantidadEstudiantes'] as int;
    }

    await db.close();

    return retornable;

  }

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
    if(result.length == 0 ){
      db.close();
      return estudiantesPorGrado;
    }
    
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

  Future<Map<String,dynamic>> casoDeCambioDeMatricula(int estudianteID)async{
    //PREPARATIVOS: OBTENER EL AÑO ESCOLAR PARA EL PRIMER CASO Y EL MAPA DE RETORNO
    //ADEMAS DE CONSULTAR EL ULTIMO RECORD DEL ESTUDIANTE PARA EL CASO  2 Y 3
    Map<String,dynamic> retornable = {
      'caso':0,
      'listado':<Ambiente>[]
    };

    final resultadoCaso2Y3 = await controladorRecord.obtenerUltimoRecord(estudianteID,false);

    final yearEscolar = (await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR',false))!.valor;
    
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    //CASO 1: SI EXISTE UNA MATRICULA DEL ESTUDIANTE PARA EL AÑO ACTUAL,
    //SE ACTUALIZARA LA MATRICULA, ENTONCES SE RETORNA 
    //EL LISTADO DE AMBIENTES DE ESE MISMO GRADO
    final resultadoCaso1 = await db.query(MatriculaEstudiante.tableName,where:'estudianteID = ? AND añoEscolar = ?',whereArgs: [estudianteID,yearEscolar]);
    if(resultadoCaso1.length > 0){
      retornable['caso'] = 1;
      retornable['listado'] = await controladorAmbientes.obtenerListadoDeAmbientesSegunAmbiente(resultadoCaso1[0]['ambienteID'] as int);
    }

    //CASO 2: SI NO EXISTE UNA MATRICULA PARA EL AÑO ACTUAL, Y EL ESTUDIANTE
    //APROBO EL AÑO PASADO, ENTONCES SE RETORNA 
    //EL LISTADO DE AMBIENTES DEL PROXIMO GRADO
    else if(resultadoCaso2Y3 != null && resultadoCaso2Y3.aprobado){
      retornable['caso'] = 2;
      retornable['listado'] = await controladorAmbientes.buscarAmbientesPorGrado(resultadoCaso2Y3.gradoCursado+1);
    }

    //CASO 3: SI NO EXISTE UNA MATRICULA PARA EL AÑO ACTUAL, Y EL ESTUDIANTE
    //REPROBO EL AÑO PASADO, ENTONCES SE RETORNA
    //EL LISTADO DE AMBIENTES DEL MISMO GRADO
    else if(resultadoCaso2Y3 != null && resultadoCaso2Y3.aprobado == false){
      retornable['caso'] = 3;
      retornable['listado'] = await controladorAmbientes.buscarAmbientesPorGrado(resultadoCaso2Y3.gradoCursado);
    }

    db.close();
    return retornable;
  }

  Future<int> cambiarMatricula(MatriculaEstudiante nuevaMatricula,int mesCambio,String genero)async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    //PARA LA ESTADISTICA DE LA MATRICULA

    // PASO 1: CONSULTAR LA MATRICULA VIEJA
    final matriculaVieja = await db.query(MatriculaEstudiante.tableName,where:'id = ?',whereArgs:[nuevaMatricula.id]);
    if(matriculaVieja[0]['ambienteID'] != nuevaMatricula.ambienteID){

      // PASO 2: CAMBIAR EN LA TABLA DE GESTION DE ESTADISTICA,
      // DONDE EL AMBIENTE VIEJO Y DE ACUERDO EL MES, AÑADIRLE UNO A LOS EGRESOS
      // PERO SOLO SI LA MATRICULA VIEJA EXISTE

      if(matriculaVieja.length != 0){
        await controladorEstadistica.addEgreso(mesCambio, matriculaVieja[0]['ambienteID'] as int,genero,false);
      }


      // PASO 3: CAMBIAR EN LA TABLA DE GESTIÓN DE ESTADISTICA,
      // DONDE EL AMBIENTE NUEVO Y DE ACUERDO EL MES, AÑADIRLE UNO A LOS INGRESOS
      await controladorEstadistica.addIngreso(mesCambio, nuevaMatricula.ambienteID,genero,false);

    }
    
    final result = await db.update(MatriculaEstudiante.tableName, nuevaMatricula.toJson(withId:true),where: 'id = ?',whereArgs: [nuevaMatricula.id]);
    
    await db.close();

    return result;
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

    final yearEscolar = await db.query(Admin.tableName,where:'opcion = ?',whereArgs:['AÑO_ESCOLAR']);

    final result = await db.insert(MatriculaEstudiante.tableName,{
      'ambienteID':ambiente.id,
      'estudianteID':estudianteId,
      'añoEscolar':yearEscolar[0]['valor']!
    });

    db.close();

    return result;

  }

}

final controladorMatriculaEstudiante = _MatriculaEstudianteController();