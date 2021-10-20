
class MatriculaDocente{

  static final String tableName = "Matricula_Docentes";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Matricula_Docentes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
      ambienteID INTEGER NOT NULL,
      docenteID INTEGER NOT NULL,
      añoEscolar VARCHAR(9) NOT NULL,

      FOREIGN KEY (ambienteID) REFERENCES Ambientes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
      
      FOREIGN KEY (docenteID) REFERENCES Usuarios (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(añoEscolar,ambienteID)
    );
  
  ''';

  int? id;
  int ambienteID;
  int docenteID;
  String yearEscolar;

  MatriculaDocente({
    this.id,
    required this.ambienteID,
    required this.docenteID,
    required this.yearEscolar
  });

  MatriculaDocente.fromForm(Map<String,dynamic> matricula) :
    ambienteID = matricula['Ambiente'],
    docenteID = matricula['Docente'],
    yearEscolar = matricula['AñoEscolar'];

  MatriculaDocente.fromMap(Map<String,dynamic> matricula) :
    id = matricula['id'],
    ambienteID = matricula['ambienteID'],
    docenteID = matricula['docenteID'],
    yearEscolar = matricula['añoEscolar'];
  
  Map<String,dynamic> toJson({bool withId = true}) => (withId) ? {
    'id':id,
    'ambienteID':ambienteID,
    'docenteID':docenteID,
    'añoEscolar':yearEscolar
  } : {
    'ambienteID':ambienteID,
    'docenteID':docenteID,
    'añoEscolar':yearEscolar
  };

}