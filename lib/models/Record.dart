

class Record {

  static final String getData = '''
  
    SELECT
      e.id AS 'estudianteID',
      re.aprobado,
      am.grado AS 'gradoCursado',
      am.seccion AS 'seccionCursada',
      ad.valor AS 'añoEscolar',
      fe.fecha_inscripcion AS 'fechaInscripcion'
    FROM Informacion_estudiantes e
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.estudianteID = e.id
    LEFT OUTER JOIN Ambientes am
      ON am.id = me.ambienteID
    LEFT OUTER JOIN Rendimiento re
      ON re.matricula_estudianteID = me.id
    LEFT OUTER JOIN Admin_Options ad
      ON ad.opcion = 'AÑO_ESCOLAR'
    LEFT OUTER JOIN Ficha_Estudiante fe
      ON fe.estudianteID = e.id
  
  ''';

  static final String tableName = "Record_Boletin_Estudiantil";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      aprobado BOOL DEFAULT false,
      gradoCursado INTEGER NOT NULL,
      seccionCursada VARCHAR(1) NOT NULL,
      añoEscolar VARCHAR(9) NOT NULL,
      fechaInscripcion VARCHAR(10) NOT NULL,

      FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(estudianteID, añoEscolar)
    );
  
  ''';

  int? id;
  int estudianteID;
  bool aprobado;
  int gradoCursado;
  String seccionCursada;
  String yearEscolar;
  String fechaInscripcion;

  Record({
    this.id,
    required this.estudianteID,
    required this.aprobado,
    required this.gradoCursado,
    required this.seccionCursada,
    required this.yearEscolar,
    required this.fechaInscripcion
  });


  //SIN fromFORM DEBIDO A QUE ESTA INSTANCIA 
  //JAMAS PUEDE SER CREADA A PARTIR DE UN FORMULARIO

  Record.fromMap(Map<String,dynamic> record) :
    id = record['id'],
    estudianteID = record['estudianteID'],
    aprobado = record['aprobado'] == 1,
    gradoCursado = record['gradoCursado'],
    seccionCursada = record['seccionCursada'],
    yearEscolar = record['añoEscolar'],
    fechaInscripcion = record['fechaInscripcion']
  ;

  Map<String,dynamic> toJson({bool withId = true}) => (withId) ? {
    'id' : id,
    'estudianteID' : estudianteID,
    'aprobado' : aprobado ? 1 : 0,
    'gradoCursado' : gradoCursado,
    'seccionCursada' : seccionCursada,
    'añoEscolar' : yearEscolar,
    'fechaInscripcion' : fechaInscripcion,
  } : {
    'estudianteID' : estudianteID,
    'aprobado' : aprobado ? 1 : 0,
    'gradoCursado' : gradoCursado,
    'seccionCursada' : seccionCursada,
    'añoEscolar' : yearEscolar,
    'fechaInscripcion' : fechaInscripcion,
  };

}