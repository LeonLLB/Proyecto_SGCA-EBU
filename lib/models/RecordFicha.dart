

class RecordFicha{
  static final String tableName = 'Record_Ficha';

  static final String testInitializer = 'SELECT id FROM $tableName';

  static final String tableInitializer = '''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      talla FLOAT NOT NULL,
      peso FLOAT NOT NULL,
      edad INTEGER NOT NULL,
      añoEscolar VARCHAR(10) NOT NULL,

      FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
    )
  
  ''';

  int? id;
  int estudianteID;
  double talla;
  double peso;
  int edad;
  String yearEscolar;

  RecordFicha({
    this.id,
    required this.estudianteID,
    required this.talla,
    required this.peso,
    required this.edad,
    required this.yearEscolar
  });  

  RecordFicha.fromMap(Map<String,dynamic> fichaEstudiante) :
    id = fichaEstudiante['id'],
    estudianteID = fichaEstudiante['estudianteID'],
    talla = fichaEstudiante['talla'],
    peso = fichaEstudiante['peso'],
    edad = fichaEstudiante['edad'],
    yearEscolar = fichaEstudiante['añoEscolar']
    ;

  Map<String,dynamic> toJson({withId: true}) => (withId) ? {
    'id': id,
    'estudianteID': estudianteID,
    'talla': talla,
    'peso': peso,
    'edad':edad,
    'añoEscolar': yearEscolar
  } : {
    'estudianteID': estudianteID,
    'talla': talla,
    'peso': peso,
    'edad':edad,
    'añoEscolar': yearEscolar
  };
}