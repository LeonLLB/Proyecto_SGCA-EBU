import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/Estadistica.dart';

class _EstadisticaController{

  Future<Map<String,Map<String,dynamic>>?> getAsistencia(int? ambienteID,int? mes,[bool closeDB = true]) async {
    if(ambienteID == null || mes == null) return null;

    Map<String,int> totalAsistencia = {
      'V':0,
      'H':0,
      'T':0
    };

    Map<String,double> mediaAsistencia = {
      'V':0,
      'H':0,
      'T':0
    };

    Map<String,double> porcentajeAsistencia = {
      'V':0,
      'H':0,
      'T':0
    };

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final results = await db.rawQuery(Estadistica.getAsistencias,[mes,ambienteID]);

    if(results.length == 0) {if(closeDB){db.close();}return null;}

    if(closeDB){db.close();}

    //PASO 1: POR CADA UNA DE ELLAS, CONTABILIZAR SUS ASISTENCIAS (TOTAL)

    Map<String,int> matricula = {
      'V':0,
      'H':0,
      'T':0
    };  
    for(var result in results){
      final cantidadAsistencias = (result['asistencias'] as String).split(',').length;
      if(result['genero'] == 'M'){
        totalAsistencia['V'] = totalAsistencia['V']! + cantidadAsistencias;
        matricula['V'] = matricula['V']! + 1;
      }else{
        totalAsistencia['H'] = totalAsistencia['H']! + cantidadAsistencias;
        matricula['H'] = matricula['H']! + 1;
      }
      totalAsistencia['T'] = totalAsistencia['T']! + cantidadAsistencias;
      matricula['T'] = matricula['T']! + 1;
    }

    //PASO 2: LAS ASISTENCIAS SE DIVIDEN ENTRE LA CANTIDAD DE LOS DIAS HABILES (MEDIA)
    mediaAsistencia['V'] = (totalAsistencia['V']! / (results[0]['dias_habiles'] as int));
    mediaAsistencia['H'] = (totalAsistencia['H']! / (results[0]['dias_habiles'] as int));
    mediaAsistencia['T'] = (totalAsistencia['T']! / (results[0]['dias_habiles'] as int));

    //PASO 3: SE MULTIPLICA EL TOTAL DE ASISTENCIAS POR 100, Y LUEGO SE DIVIDE ENTRE EL PRODUCTO DE LA MATRICULA Y LOS DIAS HABILES (PORCENTAJE)
    porcentajeAsistencia['V'] = (((totalAsistencia['V'] as int) * 100)/((matricula['V'] as int) * (results[0]['dias_habiles'] as int)));
    porcentajeAsistencia['H'] = (((totalAsistencia['H'] as int) * 100)/((matricula['H'] as int) * (results[0]['dias_habiles'] as int)));
    porcentajeAsistencia['T'] = (((totalAsistencia['T'] as int) * 100)/((matricula['T'] as int) * (results[0]['dias_habiles'] as int)));

    return {
      'Total': totalAsistencia,
      'Media': mediaAsistencia,
      'Porcentaje':porcentajeAsistencia
    };
  }

  Future<List<List<Map<String,int>>>?> getClasificacionEdadSexo(int? ambienteID,[bool closeDB = true])async{
    if(ambienteID == null) return null;

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    List<Map<String,int>> retornable1 = [];
    List<Map<String,int>> retornable2 = [];

    final results = await db.rawQuery(Estadistica.getEstudiantesParaClasificacionEdadSexo,[ambienteID]);

    int totalHembras1 = 0;
    int totalVarones1 = 0;
    int totalTotal1 = 0;
    int totalHembras2 = 0;
    int totalVarones2 = 0;
    int totalTotal2 = 0;
    
    for(var result in results){
      final edad = calcularEdad(result['fecha_nacimiento']);
      int i = 0;
      int j = 0;
      
      bool condicion1 = false;      
      bool condicion2 = false;      

      for(i=0;i < retornable1.length; i++){
        if(retornable1[i]['edad'] == edad){
          condicion1=true;
          break;
        }
      }

      for(j=0;j < retornable2.length; j++){
        if(retornable2[j]['edad'] == edad){
          condicion2=true;
          break;
        }
      }

      if(condicion1 == false){
        
        retornable1.add({
          'edad':edad,
          'V':0,
          'H':0,
          'T':0
        });
        
      }

      if(condicion2 == false){
        retornable2.add({
          'edad':edad,
          'V':0,
          'H':0,
          'T':0
        });
      }

      if(result['genero'] == 'M'){
        retornable1[i]={
          ...retornable1[i],
          'V':retornable1[i]['V']!+1,
          'T':retornable1[i]['T']!+1
        };
        totalVarones1 += 1;
        totalTotal1 += 1;
        if(result['tipo_estudiante'] == 'Repitiente'){
          retornable2[j]={
            ...retornable2[j],
            'V':retornable2[j]['V']!+1,
            'T':retornable2[j]['T']!+1
          };
          totalVarones2 += 1;
          totalTotal2 += 1;
        }
      }
      else if(result['genero'] == 'F'){
        retornable1[i]={
          ...retornable1[i],
          'H':retornable1[i]['H']!+1,
          'T':retornable1[i]['T']!+1
        };
        totalHembras1 += 1;
        totalTotal1 += 1;
        if(result['tipo_estudiante'] == 'Repitiente'){
          retornable2[j]={
            ...retornable2[j],
            'H':retornable2[j]['H']!+1,
            'T':retornable2[j]['T']!+1
          };
          totalHembras2 += 1;
          totalTotal2 += 1;
        }
      }
    }

    if(closeDB){db.close();}

    retornable1.add({'TV':totalVarones1,'TH':totalHembras1,'TT':totalTotal1});
    retornable2.add({'TV':totalVarones2,'TH':totalHembras2,'TT':totalTotal2});

    retornable1.sort((a,b)=>(b['edad'] == null) ? 0 : a['edad']!.compareTo(b['edad']as int));
    retornable2.sort((a,b)=>(b['edad'] == null) ? 0 : a['edad']!.compareTo(b['edad']as int));

    return [retornable1,retornable2];

  }

  Future<Map<String,Map<String,int>>?> getMatricula(int? ambienteID,int? mes,[bool closeDB = true]) async {
    if(ambienteID == null || mes == null) return null;

    Map<String,int> _abstractMap = {
      'V':0,
      'H':0,
      'T':0
    };

    Map<String,int> diasHabiles = {..._abstractMap};
    Map<String,int> matricula = {..._abstractMap};
    Map<String,int> primerDia = {..._abstractMap};
    Map<String,int> egresos = {..._abstractMap};
    Map<String,int> ingresos = {..._abstractMap};

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final results = await db.rawQuery(Estadistica.getMatriculas,[mes,ambienteID]);

    if(results.length == 0) {if(closeDB){db.close();}return null;}

    if(closeDB){db.close();}

    //PASO 1: DIAS HABILES
    diasHabiles['V'] = diasHabiles['H'] =  diasHabiles['T'] = results[0]['dias_habiles'] as int;

    //PASO 2: MATRICULA
    matricula['V'] = results.where((result) => result['genero'] == 'M').toList().length;
    matricula['H'] = results.where((result) => result['genero'] == 'F').toList().length;
    matricula['T'] = matricula['H']! + matricula['V']!;

    //PASO 3: EGRESOS
    egresos['V'] = results[0]['egresos_varones'] as int ; 
    egresos['H'] = results[0]['egresos_hembras'] as int ; 
    egresos['T'] = (egresos['V'] as int) + (egresos['H'] as int); 

    //PASO 4: INGRESOS
    ingresos['V'] = results[0]['ingresos_varones'] as int ; 
    ingresos['H'] = results[0]['ingresos_hembras'] as int ; 
    ingresos['T'] = (ingresos['V'] as int) + (ingresos['H'] as int);

    //PASO 5: 1° DIA DEL MES

    primerDia['V'] = (egresos['V'] as int) + (matricula['V'] as int) - (ingresos['V'] as int);
    primerDia['H'] = (egresos['H'] as int) + (matricula['H'] as int) - (ingresos['H'] as int);
    primerDia['T'] = (egresos['T'] as int) + (matricula['T'] as int) - (ingresos['T'] as int);

    Map<String,Map<String,int>> retornable = {
      'Dias Habiles':diasHabiles,
      'Matricula':matricula,
      '1° Dia': primerDia,
      'Egresos':egresos,
      'Ingresos':ingresos,
      'Matricula Final': matricula,
    };

    return retornable;
  }

  Future<int> cambiarDiasHabiles(int ambienteID, int mes, int diasHabiles) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final resultQ = await db.query(Estadistica.tableName,where:'ambienteID = ? AND mes = ?',whereArgs:[ambienteID,mes]);

    if(resultQ.length == 0){
      final result = await db.insert(Estadistica.tableName,{'mes':mes,'ambienteID':ambienteID,'dias_habiles':diasHabiles});
      return result;
    }else{
      final result = await db.rawUpdate(Estadistica.modificarAsistencia,[diasHabiles,ambienteID,mes]);
      return result;
    }
  }

  Future<int> addIngreso(int mes, int ambienteID,String genero,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final viejaGestion = await db.query(Estadistica.tableName, where:'mes = ? AND ambienteID = ?', whereArgs:[mes,ambienteID]);

    if(viejaGestion.length == 0){
      if (genero == 'M') {
        final result = await db.insert(Estadistica.tableName,{'mes':mes,'ambienteID':ambienteID,'ingresos_varones':1});
        
        if(closeDB){db.close();}
        
        return result;
      }else{
        final result = await db.insert(Estadistica.tableName,{'mes':mes,'ambienteID':ambienteID,'ingresos_hembras':1});
        
        if(closeDB){db.close();}
        
        return result;
      }
    }
    else{
      if (genero == 'M') {
        final result = await db.rawUpdate(Estadistica.modificarMatriculaIngresosVarones,[((viejaGestion[0]['ingresos_varones']! as int) + 1),ambienteID,mes]);
        
        if(closeDB){db.close();}
        
        return result;
      }else{
        final result = await db.rawUpdate(Estadistica.modificarMatriculaIngresosHembras,[((viejaGestion[0]['ingresos_varones']! as int) + 1),ambienteID,mes]);
        
        if(closeDB){db.close();}
        
        return result;
      }
    }
    
     
  }
  Future<int> addEgreso(int mes, int ambienteID,String genero,[bool closeDB = true])async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final viejaGestion = await db.query(Estadistica.tableName, where:'mes = ? AND ambienteID = ?', whereArgs:[mes,ambienteID]);

    if(viejaGestion.length == 0){
      if (genero == 'M') {
        final result = await db.insert(Estadistica.tableName,{'mes':mes,'ambienteID':ambienteID,'egresos_varones':1});
        
        if(closeDB){db.close();}
        
        return result;
      }else{
        final result = await db.insert(Estadistica.tableName,{'mes':mes,'ambienteID':ambienteID,'egresos_hembras':1});
        
        if(closeDB){db.close();}
        
        return result;
      }
    }
    else{
      if (genero == 'M') {
        final result = await db.rawUpdate(Estadistica.modificarMatriculaEgresosVarones,[((viejaGestion[0]['egresos_varones']! as int) + 1),ambienteID,mes]);
        
        if(closeDB){db.close();}
        
        return result;
      }else{
        final result = await db.rawUpdate(Estadistica.modificarMatriculaEgresosHembras,[((viejaGestion[0]['egresos_varones']! as int) + 1),ambienteID,mes]);
        
        if(closeDB){db.close();}
        
        return result;
      }
    }
    
  }


}

final controladorEstadistica = _EstadisticaController();