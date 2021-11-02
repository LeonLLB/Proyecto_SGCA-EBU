import 'package:intl/intl.dart';

class Asistencia{

  static final String tableName='Asistencia_Semanal';

  static final String testInitializer='SELECT id FROM $tableName';

  static final String tableInitializer='''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      lunes BOOL NOT NULL,
      martes BOOL NOT NULL,
      miercoles BOOL NOT NULL,
      jueves BOOL NOT NULL,
      viernes BOOL NOT NULL,
      inicio_semana VARCHAR(10) NOT NULL,
      fin_semana VARCHAR(10) NOT NULL,
      mes INTEGER NOT NULL,

      FOREIGN KEY (estudianteID) REFERENCES Estudiante (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
    );
  
  ''';

  int? id;
  int estudianteID;
  bool lunes; 
  bool martes;
  bool miercoles;
  bool jueves;
  bool viernes;
  DateTime inicioSemana;
  DateTime finSemana; 
  int mes;

  Asistencia({
    this.id,
    required this.estudianteID,
    required this.lunes, 
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
    required this.inicioSemana,
    required this.finSemana, 
    required this.mes,
  });

  Asistencia.fromForm(Map<String,dynamic> asistencia) :
    estudianteID = asistencia['EstudianteID'],
    lunes = asistencia['Lunes'], 
    martes = asistencia['Martes'],
    miercoles = asistencia['Miercoles'],
    jueves = asistencia['Jueves'],
    viernes = asistencia['Viernes'],
    inicioSemana = asistencia['InicioSemana'],
    finSemana = asistencia['FinSemana'], 
    mes = asistencia['Mes'];
  
  Asistencia.fromMap(Map<String,dynamic> asistencia) :
    estudianteID = asistencia['EstudianteID'],
    lunes = asistencia['lunes'] == 1 , 
    martes = asistencia['martes'] == 1 ,
    miercoles = asistencia['miercoles'] == 1 ,
    jueves = asistencia['jueves'] == 1 ,
    viernes = asistencia['viernes'] == 1 ,
    inicioSemana = DateTime(asistencia['inicioSemana'].split('/')[2],asistencia['inicioSemana'].split('/')[1],asistencia['inicioSemana'].split('/')[0]),
    finSemana = DateTime(asistencia['finSemana'].split('/')[2],asistencia['finSemana'].split('/')[1],asistencia['finSemana'].split('/')[0]), 
    mes = asistencia['mes'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'estudianteID' : estudianteID,
    'lunes' :  lunes,
    'martes' : martes,
    'miercoles' : miercoles,
    'jueves' : jueves,
    'viernes' : viernes,
    'inicioSemana' : DateFormat.yMd().format(inicioSemana),
    'finSemana' :  DateFormat.yMd().format(finSemana),
    'mes' : mes
  }:{
    'estudianteID' : estudianteID,
    'lunes' :  lunes,
    'martes' : martes,
    'miercoles' : miercoles,
    'jueves' : jueves,
    'viernes' : viernes,
    'inicioSemana' : DateFormat.yMd().format(inicioSemana),
    'finSemana' :  DateFormat.yMd().format(finSemana),
    'mes' : mes
  };

}

class AsistenciaTemporal {

  int estudianteID;
  bool lunes; 
  bool martes;
  bool miercoles;
  bool jueves;
  bool viernes;
  int numeroSemana;

  AsistenciaTemporal({
    required this.estudianteID,
    required this.lunes,
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
    required this.numeroSemana
  });

}