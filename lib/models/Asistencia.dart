class Asistencia{

  static final String tableName='Asistencia_diaria';

  static final String testInitializer='SELECT id FROM $tableName';

  static final String tableInitializer='''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      asistio BOOL NOT NULL,
      dia INTEGER NOT NULL,
      mes INTEGER NOT NULL,
      añoEscolar VARCHAR(9),

      FOREIGN KEY (estudianteID) REFERENCES Estudiante (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(dia,mes,añoEscolar,estudianteID)
    );
  
  ''';

  int? id;
  int estudianteID;
  bool asistio; 
  int dia;
  int mes;

  Asistencia({
    this.id,
    required this.estudianteID,
    required this.asistio, 
    required this.dia,
    required this.mes
  });

  Asistencia.fromForm(Map<String,dynamic> asistencia) :
    estudianteID = asistencia['EstudianteID'],
    asistio = asistencia['Asistio'],
    dia = asistencia['Dia'],
    mes = asistencia['Mes'];
  
  Asistencia.fromMap(Map<String,dynamic> asistencia) :
    id = asistencia['id'],
    estudianteID = asistencia['estudianteID'],
    asistio = asistencia['asistio'] == 1 , 
    dia = asistencia['dia'],
    mes = asistencia['mes'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'estudianteID' : estudianteID,
    'asistio' :  asistio,
    'dia' : dia,
    'mes' : mes
  }:{
    'estudianteID' : estudianteID,
    'asistio' :  asistio,
    'dia' : dia,
    'mes' : mes
  };

}