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
      numero_semana INTEGER NOT NULL,
      mes INTEGER NOT NULL,
      añoEscolar VARCHAR(9),

      FOREIGN KEY (estudianteID) REFERENCES Estudiante (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(mes,numero_semana,estudianteID)
    );
  
  ''';

  int? id;
  int estudianteID;
  bool lunes; 
  bool martes;
  bool miercoles;
  bool jueves;
  bool viernes;
  int mes;
  int numeroSemana;

  Asistencia({
    this.id,
    required this.estudianteID,
    required this.lunes, 
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
    required this.numeroSemana,
    required this.mes,
  });

  Asistencia.fromForm(Map<String,dynamic> asistencia) :
    estudianteID = asistencia['EstudianteID'],
    lunes = asistencia['Lunes'], 
    martes = asistencia['Martes'],
    miercoles = asistencia['Miercoles'],
    jueves = asistencia['Jueves'],
    viernes = asistencia['Viernes'],
    numeroSemana = asistencia['NumeroSemana'],
    mes = asistencia['Mes'];
  
  Asistencia.fromMap(Map<String,dynamic> asistencia) :
    estudianteID = asistencia['EstudianteID'],
    lunes = asistencia['lunes'] == 1 , 
    martes = asistencia['martes'] == 1 ,
    miercoles = asistencia['miercoles'] == 1 ,
    jueves = asistencia['jueves'] == 1 ,
    viernes = asistencia['viernes'] == 1 ,
    numeroSemana = asistencia['numero_semana'],
    mes = asistencia['mes'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'estudianteID' : estudianteID,
    'lunes' :  lunes,
    'martes' : martes,
    'miercoles' : miercoles,
    'jueves' : jueves,
    'viernes' : viernes,
    'numero_semana' : numeroSemana,
    'mes' : mes
  }:{
    'estudianteID' : estudianteID,
    'lunes' :  lunes,
    'martes' : martes,
    'miercoles' : miercoles,
    'jueves' : jueves,
    'viernes' : viernes,
    'numero_semana' : numeroSemana,
    'mes' : mes
  };

}