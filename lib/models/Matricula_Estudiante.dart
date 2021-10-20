
class MatriculaEstudiante{

  static final String tableName = "Matricula_Estudiantes";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Matricula_Estudiantes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
      ambienteID INTEGER NOT NULL,
      estudianteID INTEGER NOT NULL,
      añoEscolar VARCHAR(9) NOT NULL,

      FOREIGN KEY (ambienteID) REFERENCES Ambientes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
      
      FOREIGN KEY (estudianteID) REFERENCES Estudiantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(añoEscolar,ambienteID,estudianteID)
    );
  
  ''';

  int? id;
  int ambienteID;
  int estudianteID;
  String yearEscolar;

  MatriculaEstudiante({
    this.id,
    required this.ambienteID,
    required this.estudianteID,
    required this.yearEscolar
  });

  MatriculaEstudiante.fromForm(Map<String,dynamic> matricula) :
    ambienteID = matricula['Ambiente'],
    estudianteID = matricula['Estudiante'],
    yearEscolar = matricula['AñoEscolar'];

  MatriculaEstudiante.fromMap(Map<String,dynamic> matricula) :
    id = matricula['id'],
    ambienteID = matricula['ambienteID'],
    estudianteID = matricula['estudianteID'],
    yearEscolar = matricula['añoEscolar'];
  
  Map<String,dynamic> toJson({bool withId = true}) => (withId) ? {
    'id':id,
    'ambienteID':ambienteID,
    'estudianteID':estudianteID,
    'añoEscolar':yearEscolar
  } : {
    'ambienteID':ambienteID,
    'estudianteID':estudianteID,
    'añoEscolar':yearEscolar
  };

}