

class Ambiente {

  static final String tableName = "Ambientes";
  
  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Ambientes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      grado INTEGER NOT NULL,
      seccion CHAR(1) NOT NULL,
      turno CHAR(1) NOT NULL
    )
  
  ''';

  int? id;
  int grado;
  String seccion;
  String turno;

  Ambiente({
    this.id,
    required this.grado,
    required this.seccion,
    required this.turno
  });

  Ambiente.fromForm(Map<String,dynamic> ambiente) :
    grado = ambiente['Grado'],
    seccion = ambiente['Sección'],
    turno = ambiente['Turno'];

  Ambiente.fromMap(Map<String,dynamic> ambiente) :
    id = ambiente['id'],
    grado = ambiente['grado'],
    seccion = ambiente['sección'],
    turno = ambiente['turno'];
  
  Map<String,dynamic> toJson({bool withId = true}) => (withId) ? {
    'id':id,
    'grado' : this.grado,
    'seccion' : this.seccion,
    'turno' : this.turno
  } : {
    'grado' : this.grado,
    'seccion' : this.seccion,
    'turno' : this.turno
  };

}