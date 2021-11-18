
class MatriculaEstudiante{

  static final String cantidadDeEstudiantes = '''
  
    SELECT 
      am.id,
      COUNT(me.ambienteID = am.id) cantidadEstudiantes
    FROM Ambientes am
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = am.id
    WHERE am.id = ?;
  
  ''';

  static final String cantidadDeEstudiantesPorGrado = '''
  
    SELECT 
      am.id,
      COUNT(me.ambienteID = am.id) cantidadEstudiantes
    FROM Ambientes am
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = am.id
    WHERE am.grado = ?;
  
  ''';

  static final String cantidadDeEstudiantesPorAmbiente = '''
  
    SELECT 
      am.id,
      COUNT(me.ambienteID = am.id) cantidadEstudiantes
    FROM Ambientes am
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.ambienteID = am.id
    WHERE am.id = ?;
  
  ''';

  static final String obtenerMatriculaCompleta = '''
  
  SELECT
    me.id,
    md.id AS 'matriculaDocente.id',
    me."añoEscolar",
    e.id AS 'estudiante.id',
    e.nombres AS 'estudiante.nombres',
    e.apellidos AS 'estudiante.apellidos',
    e.cedula,
    e.fecha_nacimiento,
    d.nombres AS 'docente.nombres',
    d.apellidos AS 'docente.apellidos',
    am.grado,
    am.seccion,
    am.turno
  FROM Matricula_Estudiantes me
  LEFT OUTER JOIN Informacion_estudiantes e
    ON me.estudianteID = e.id
  LEFT OUTER JOIN Matricula_Docentes md
    ON md.ambienteID = me.ambienteID
  LEFT OUTER JOIN Usuarios d
    ON md.docenteID = d.id
  LEFT OUTER JOIN Ambientes am
    ON am.id = me.ambienteID
  WHERE am.id = ?;

  ''';

  static final String tableName = "Matricula_Estudiantes";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Matricula_Estudiantes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ambienteID INTEGER NOT NULL,
      estudianteID INTEGER NOT NULL,
      añoEscolar VARCHAR(9) NOT NULL,

      FOREIGN KEY (ambienteID) REFERENCES Ambientes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
      
      FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes  (id)
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