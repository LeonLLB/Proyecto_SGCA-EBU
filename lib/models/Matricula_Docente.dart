
class MatriculaDocente{

  static final String buscarExistenciaMatricula = '''
    SELECT 
      a.valor AS 'añoEscolar',
      COUNT(CASE WHEN am.grado = ? AND am.seccion = ? THEN 1 ELSE NULL END) Num 
    FROM Matricula_Docentes md
    LEFT OUTER JOIN Ambientes am
      ON am.id = md.ambienteID
    LEFT OUTER JOIN Admin_Options a
      ON a.opcion = 'AÑO_ESCOLAR'
    WHERE 'añoEscolar' = ?
    ;
  ''';

  static final String fullSearch = '''
  
    SELECT      
      am.grado,
      am.seccion,
      md."añoEscolar",
      COUNT(CASE WHEN me.ambienteID = md.ambienteID THEN 1 ELSE NULL END) NumeroEstudiantes,
      d.nombres,
      d.apellidos,
      d.cedula,
      d.numero,
      d.correo,
      d.direccion,
    FROM Matricula_Docentes md
    LEFT OUTER JOIN Usuarios d
      ON d.cedula = ?
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = md.ambienteID
    LEFT OUTER JOIN Ambientes am
      ON md.ambienteID = am.id;
  ''';

  static final String tableName = "Matricula_Docentes";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Matricula_Docentes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
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