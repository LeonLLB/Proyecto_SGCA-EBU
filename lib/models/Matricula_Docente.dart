
class MatriculaDocente{

  static final String matriculaCompletaSegunAmbientes = '''
  
  SELECT
	  md.id,     
    am.grado,
    am.seccion,
    am.turno,
    md."añoEscolar",      
    d.nombres,
    d.apellidos,
    d.cedula,
    d.numero,
    d.correo,      
    d.direccion
  FROM Ambientes am
  LEFT OUTER JOIN Matricula_Docentes md
    ON am.id = md.ambienteID
  LEFT OUTER JOIN Usuarios d
    ON d.id = md.docenteID
  LEFT OUTER JOIN Matricula_Estudiantes me
    ON me.ambienteID = md.ambienteID;
  
  ''';

  static final String cantidadDeEstudiantes = '''
  
    SELECT 
      md.id,
      COUNT(me.ambienteID = md.ambienteID) cantidadEstudiantes
    FROM Matricula_Docentes md
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = md.ambienteID
    WHERE md.id = ?;

  ''';

  static final String buscarExistenciaMatricula = '''
    SELECT
      md.id
    FROM Matricula_Docentes md
    WHERE añoEscolar = ? AND md.ambienteID = ?
        ;
  ''';

  static final String fullSearch = '''
  
    SELECT
      md.id,      
      am.grado,
      am.seccion,
      md."añoEscolar",
      COUNT(CASE WHEN me.ambienteID = md.ambienteID THEN 1 ELSE NULL END) NumeroEstudiantes,
      d.nombres,
      d.apellidos,
      d.cedula,
      d.numero,
      d.correo,
      d.direccion
    FROM Matricula_Docentes md
    LEFT OUTER JOIN Usuarios d
      ON d.id = md.docenteID
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = md.ambienteID
    LEFT OUTER JOIN Ambientes am
      ON md.ambienteID = am.id
    WHERE d.cedula = ?;
  ''';

   static final String fullSearchPorGrado = '''
  
    SELECT
      md.id,      
      am.grado,
      am.seccion,
      md."añoEscolar",
      COUNT(CASE WHEN me.ambienteID = md.ambienteID THEN 1 ELSE NULL END) NumeroEstudiantes,
      d.nombres,
      d.apellidos,
      d.cedula,
      d.numero,
      d.correo,
      d.direccion
    FROM Matricula_Docentes md
    LEFT OUTER JOIN Usuarios d
      ON d.id = md.docenteID
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = md.ambienteID
    LEFT OUTER JOIN Ambientes am
      ON md.ambienteID = am.id
    WHERE am.grado = ? AND am.seccion = ?
    ;
    
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