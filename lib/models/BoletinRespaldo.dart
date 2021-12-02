

class BoletinRespaldo{

static final String tableName = 'BoletinesR';

  static final String testInitializer = 'SELECT id FROM $tableName';

  static final String tableInitializer = '''
  
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    egresadoID INTEGER NOT NULL,
    aprobado BOOL,
    gradoCursado INTEGER NOT NULL,
    seccionCursada VARCHAR(1) NOT NULL,
    añoEscolar VARCHAR(9) NOT NULL,
    fechaInscripcion VARCHAR(10) NOT NULL,

    FOREIGN KEY (egresadoID) REFERENCES EgresadosR (id)
    	ON UPDATE CASCADE
    	ON DELETE CASCADE

    UNIQUE(egresadoID, añoEscolar)
  );
  
  ''';

  int? id;
  int egresadoID;
  bool aprobado;
  int gradoCursado;
  String seccionCursada;
  String yearEscolar;
  String fechaInscripcion;

  BoletinRespaldo({
    this.id,
    required this.egresadoID,
    required this.aprobado,
    required this.gradoCursado,
    required this.seccionCursada,
    required this.yearEscolar,
    required this.fechaInscripcion,
  });

  BoletinRespaldo.fromMap(Map<String,dynamic> boletinR) : 
    id = boletinR['id'],
    egresadoID = boletinR['egresadoID'],
    aprobado = (boletinR['aprobado'] == 1),
    gradoCursado = boletinR['gradoCursado'],
    seccionCursada = boletinR['seccionCursada'],
    yearEscolar = boletinR['añoEscolar'],
    fechaInscripcion = boletinR['fechaInscripcion'];

  Map<String, dynamic> toJson([bool withId = true]) => (withId) ? {
    'id' : id,
    'egresadoID' : egresadoID,
    'aprobado' : (aprobado) ? 1 : 0,
    'gradoCursado' : gradoCursado,
    'seccionCursada' : seccionCursada,
    'añoEscolar' : yearEscolar,
    'fechaInscripcion': fechaInscripcion 
  } : {
    'egresadoID' : egresadoID,
    'aprobado' : (aprobado) ? 1 : 0,
    'gradoCursado' : gradoCursado,
    'seccionCursada' : seccionCursada,
    'añoEscolar' : yearEscolar,
    'fechaInscripcion' :fechaInscripcion 
  } ;

}