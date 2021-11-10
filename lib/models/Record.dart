

class Record {

  static final String tableName = "Record_Estudiantil";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      aprobado BOOL NOT NULL DEFAULT false,
      gradoCursado VARCHAR(6) NOT NULL,
      añoEscolar VARCHAR(9) NOT NULL,

      FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(estudianteID, añoEscolar)
    );
  
  ''';

  int? id;
  int estudianteID;
  bool aprobado;
  String gradoCursado;
  String yearEscolar;

  Record({
    this.id,
    required this.estudianteID,
    required this.aprobado,
    required this.gradoCursado,
    required this.yearEscolar
  });


  //SIN fromFORM DEBIDO A QUE ESTA INSTANCIA 
  //JAMAS PUEDE SER CREADA A PARTIR DE UN FORMULARIO

  Record.fromMap(Map<String,dynamic> record) :
    id = record['id'],
    estudianteID = record['estudianteID'],
    aprobado = record['aprobado'],
    gradoCursado = record['gradoCursado'],
    yearEscolar = record['añoEscolar']
  ;

  Map<String,dynamic> toJson({bool withId = true}) => (withId) ? {
    'id' : id,
    'estudianteID' : estudianteID,
    'aprobado' : aprobado,
    'gradoCursado' : gradoCursado,
    'añoEscolar' : yearEscolar
  } : {
    'estudianteID' : estudianteID,
    'aprobado' : aprobado,
    'gradoCursado' : gradoCursado,
    'añoEscolar' : yearEscolar
  };

}