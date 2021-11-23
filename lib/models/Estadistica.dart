

class Estadistica{

  static final String tableName = 'Gestion_Estadistica';

  static final String testInitializer= 'SELECT id FROM $tableName';

  static final String tableInitializer = '''
  
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ambienteID INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    ingresos INTEGER NOT NULL DEFAULT 0,
    egresos INTEGER NOT NULL DEFAULT 0,
    dias_habiles INTEGER NOT NULL DEFAULT 0,

    FOREIGN KEY (ambienteID) REFERENCES Ambientes  (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
    
    UNIQUE(mes,ambienteID)
  );
  
  ''';

  static final String getEstudiantesParaClasificacionEdadSexo = '''
  
  SELECT
    e.id AS 'estudiante.id',
    e.genero,
	  fe.tipo_estudiante,
    e.fecha_nacimiento
  FROM Matricula_Estudiantes me
  LEFT OUTER JOIN Informacion_estudiantes e
    ON me.estudianteID = e.id
  LEFT OUTER JOIN Ambientes am
    ON am.id = me.ambienteID
  LEFT OUTER JOIN Ficha_Estudiante fe
	  ON fe.estudianteID = e.id
  WHERE am.id = ?;
  
  ''';

  static final String getAsistencias = '''
  
  SELECT
    e.id,
    e.genero,
    a.asistencias,
    ge.dias_habiles
  FROM Asistencia_mensual a
  LEFT OUTER JOIN Informacion_estudiantes e
    ON a.estudianteID = e.id
  LEFT OUTER JOIN Matricula_Estudiantes me
    ON e.id = me.estudianteID
  LEFT OUTER JOIN Ambientes am
    ON am.id = me.ambienteID
  LEFT OUTER JOIN Gestion_Estadistica ge
    ON ge.mes = a.mes
  WHERE a.mes = ? AND am.id = ?;
  
  ''';

  static final String modificarMatriculaIngresos = '''

  UPDATE $tableName SET ingresos = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  static final String modificarMatriculaEgresos = '''

  UPDATE $tableName SET egresos = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  static final String modificarAsistencia = '''

  UPDATE $tableName SET dias_habiles = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  int? id;
  int ambienteID;
  int mes;
  int ingresos;
  int egresos;
  int diasHabiles;

  Estadistica({
    this.id,
    required this.ambienteID,
    required this.mes,
    required this.ingresos,
    required this.egresos,
    required this.diasHabiles,
  });

  Estadistica.fromMap(Map<String,dynamic> estadistica) :
    id = estadistica['id'],
    ambienteID = estadistica['ambienteID'],
    mes = estadistica['mes'],
    ingresos = estadistica['ingresos'],
    egresos = estadistica['egresos'],
    diasHabiles = estadistica['dias_habiles'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'ambienteID' : ambienteID,
    'mes' : mes,
    'ingresos' : ingresos,
    'egresos' : egresos,
    'dias_habiles' :diasHabiles
  }:{
    'ambienteID' : ambienteID,
    'mes' : mes,
    'ingresos' : ingresos,
    'egresos' : egresos,
    'dias_habiles' :diasHabiles
  };

}