

class Estadistica{

  static final String tableName = 'Gestion_Estadistica';

  static final String testInitializer= 'SELECT id FROM $tableName';

  static final String tableInitializer = '''
  
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ambienteID INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    ingresos_varones INTEGER NOT NULL DEFAULT 0,
    ingresos_hembras INTEGER NOT NULL DEFAULT 0,
    egresos_varones INTEGER NOT NULL DEFAULT 0,
    egresos_hembras INTEGER NOT NULL DEFAULT 0,
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

  static final String getMatriculas = '''
  
    SELECT
      e.id,
      e.genero,
      ge.dias_habiles,
      ge.ingresos_varones,
      ge.ingresos_hembras,
      ge.egresos_varones,
      ge.egresos_hembras
    FROM Gestion_Estadistica ge
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON ge.ambienteID = me.ambienteID
    LEFT OUTER JOIN Informacion_estudiantes e
      ON me.estudianteID = e.id
    LEFT OUTER JOIN Ambientes am
      ON am.id = me.ambienteID
    WHERE ge.mes = ? AND am.id = ?;
  
  ''';

  static final String modificarMatriculaIngresosHembras = '''

  UPDATE $tableName SET ingresos_hembras = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  static final String modificarMatriculaEgresosHembras = '''

  UPDATE $tableName SET egresos_hembras = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';
  static final String modificarMatriculaIngresosVarones = '''

  UPDATE $tableName SET ingresos_varones = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  static final String modificarMatriculaEgresosVarones = '''

  UPDATE $tableName SET egresos_varones = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  static final String modificarAsistencia = '''

  UPDATE $tableName SET dias_habiles = ? WHERE ambienteID = ? AND mes = ?;
  
  ''';

  int? id;
  int ambienteID;
  int mes;
  int ingresosHembras;
  int egresosHembras;
  int ingresosVarones;
  int egresosVarones;
  int diasHabiles;

  Estadistica({
    this.id,
    required this.ambienteID,
    required this.mes,
    required this.ingresosHembras,
    required this.ingresosVarones,
    required this.egresosHembras,
    required this.egresosVarones,
    required this.diasHabiles,
  });

  Estadistica.fromMap(Map<String,dynamic> estadistica) :
    id = estadistica['id'],
    ambienteID = estadistica['ambienteID'],
    mes = estadistica['mes'],
    ingresosVarones = estadistica['ingresos_varones'],
    egresosVarones = estadistica['egresos_varones'],
    ingresosHembras = estadistica['ingresos_hembras'],
    egresosHembras = estadistica['egresos_hembras'],
    diasHabiles = estadistica['dias_habiles'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'ambienteID' : ambienteID,
    'mes' : mes,
    'ingresos_hembras' : ingresosHembras,
    'egresos_hembras' : egresosHembras,
    'ingresos_varones' : ingresosVarones,
    'egresos_varones' : egresosVarones,
    'dias_habiles' :diasHabiles
  }:{
    'ambienteID' : ambienteID,
    'mes' : mes,
    'ingresos_hembras' : ingresosHembras,
    'egresos_hembras' : egresosHembras,
    'ingresos_varones' : ingresosVarones,
    'egresos_varones' : egresosVarones,
    'dias_habiles' :diasHabiles
  };

}