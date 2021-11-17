

class FichaEstudiante{

  static final String getFichaCompleta = '''
  
    SELECT
      fe.id,
      e.nombres,e.apellidos,
      e.id AS 'e.id',
      e.cedula,
      e.lugar_nacimiento,e.estado_nacimiento,e.fecha_nacimiento,
      e.genero,
      fe.tipo_estudiante,
      fe.fecha_inscripcion,
      fe.procedencia,
      fe.talla,fe.peso,
      fe.alergia,fe.asma,fe.cardiaco,fe.tipaje,fe.respiratorio,fe.detalles,
      r.nombres AS 'r.nombres',
      r.apellidos AS 'r.apellidos',
      r.cedula AS 'r.cedula',
      r.numero AS 'r.numero',
      r.ubicacion AS 'r.ubicacion',
      eur.parentesco AS 'r.parentesco',	
      me."añoEscolar",
      am.grado,
      am.seccion,am.turno,
      d.nombres AS 'd.nombres',
      d.apellidos AS 'd.apellidos',
      d.cedula AS 'd.cedula'
    FROM Estudiante_U_Representante eur
    LEFT OUTER JOIN Representantes r
      ON r.id = eur.representanteID
    LEFT OUTER JOIN Ficha_Estudiante fe
      ON fe.estudianteID = eur.estudianteID
    LEFT OUTER JOIN Informacion_estudiantes e
      ON fe.estudianteID = e.id
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON me.estudianteID = e.id
    LEFT OUTER JOIN Matricula_Docentes md
      ON md.ambienteID = me.ambienteID
    LEFT OUTER JOIN Usuarios d
      ON d.id = md.docenteID
    LEFT OUTER JOIN Ambientes am
      ON am.id = me.ambienteID
    WHERE e.cedula = ?

  ''';

  static final String tableName = 'Ficha_Estudiante';

  static final String testInitializer = 'SELECT id FROM $tableName';

  static final String tableInitializer = '''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      tipo_estudiante VARCHAR(10) NOT NULL,
      fecha_inscripcion VARCHAR(10) NOT NULL,
      procedencia VARCHAR(11) NOT NULL,
      talla FLOAT NOT NULL,
      peso FLOAT NOT NULL,
      alergia BOOL NOT NULL,
      asma BOOL NOT NULL,
      cardiaco BOOL NOT NULL,
      tipaje BOOL NOT NULL,
      respiratorio BOOL NOT NULL,
      detalles TEXT,

      FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
    )
  
  ''';

  int? id;
  int estudianteID;
  String tipoEstudiante;
  String fechaInscripcion;
  String procedencia;
  double talla;
  double peso;
  bool alergia;
  bool asma;
  bool cardiaco;
  bool tipaje;
  bool respiratorio;
  String detalles;

  FichaEstudiante({
    this.id,
    required this.estudianteID,
    required this.tipoEstudiante,
    required this.fechaInscripcion,
    required this.procedencia,
    required this.talla,
    required this.peso,
    required this.alergia,
    required this.asma,
    required this.cardiaco,
    required this.tipaje,
    required this.respiratorio,
    required this.detalles
  });

  FichaEstudiante.fromForm(Map<String,dynamic> fichaEstudiante) :
    id = (fichaEstudiante['id'] == null) ? null : fichaEstudiante['id'],
    estudianteID = fichaEstudiante['EstudianteID'],
    tipoEstudiante = fichaEstudiante['Tipo'],
    fechaInscripcion = fichaEstudiante['FechaInscripcion'],
    procedencia = fichaEstudiante['Procedencia'],
    talla = double.parse(fichaEstudiante['Talla']),
    peso = double.parse(fichaEstudiante['Peso']),
    alergia = fichaEstudiante['Alergia'],
    asma = fichaEstudiante['Asma'],
    cardiaco = fichaEstudiante['Cardiaco'],
    tipaje = fichaEstudiante['Tipaje'],
    respiratorio = fichaEstudiante['Respiratorio'],
    detalles = fichaEstudiante['Detalles']
    ;

  FichaEstudiante.fromMap(Map<String,dynamic> fichaEstudiante) :
    id = fichaEstudiante['id'],
    estudianteID = fichaEstudiante['estudianteID'],
    tipoEstudiante = fichaEstudiante['tipo_estudiante'],
    fechaInscripcion = fichaEstudiante['fecha_inscripcion'],
    procedencia = fichaEstudiante['procedencia'],
    talla = fichaEstudiante['talla'],
    peso = fichaEstudiante['peso'],
    alergia = fichaEstudiante['alergia'] == 1,
    asma = fichaEstudiante['asma'] == 1,
    cardiaco = fichaEstudiante['cardiaco'] == 1,
    tipaje = fichaEstudiante['tipaje'] == 1,
    respiratorio = fichaEstudiante['respiratorio'] == 1,
    detalles = fichaEstudiante['detalles']
    ;

  Map<String,dynamic> toJson({withId: true}) => (withId) ? {
    'id': id,
    'estudianteID': estudianteID,
    'tipo_estudiante': tipoEstudiante,
    'fecha_inscripcion': fechaInscripcion,
    'procedencia': procedencia,
    'talla': talla,
    'peso': peso,
    'alergia': alergia ? 1 : 0,
    'asma': asma ? 1 : 0,
    'cardiaco': cardiaco ? 1 : 0,
    'tipaje': tipaje ? 1 : 0,
    'respiratorio': respiratorio ? 1 : 0,
    'detalles': detalles
  } : {
    'estudianteID': estudianteID,
    'tipo_estudiante': tipoEstudiante,
    'fecha_inscripcion': fechaInscripcion,
    'procedencia': procedencia,
    'talla': talla,
    'peso': peso,
    'alergia': alergia ? 1 : 0,
    'asma': asma ? 1 : 0,
    'cardiaco': cardiaco ? 1 : 0,
    'tipaje': tipaje ? 1 : 0,
    'respiratorio': respiratorio ? 1 : 0,
    'detalles': detalles
  };

}