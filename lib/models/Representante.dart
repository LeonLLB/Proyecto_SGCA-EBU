

class Representante{
  
  static final String tableName = "Representantes";

  static final String testInitializer = "SELECT id FROM Representantes";

  static final String tableInitializer = '''
  
    CREATE TABLE Representantes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nombres VARCHAR(20) NOT NULL, 
      apellidos VARCHAR(20) NOT NULL,
      cedula INT UNIQUE NOT NULL,
      numero VARCHAR(11) NOT NULL,
      ubicacion VARCHAR(30) NOT NULL
    );
  
  ''';

  int? id;
  String nombres;
  String apellidos;
  int cedula;
  String numero;
  String ubicacion;

  Representante({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.numero,
    required this.ubicacion
  });

  Representante.fromForm(Map<String,dynamic> representante) :
    nombres = representante['Nombres'],
    apellidos = representante['Apellidos'],
    cedula = representante['Cedula'],
    numero = representante['Numero'],
    ubicacion = representante['Ubicacion'];

  Representante.fromMap(Map<String,dynamic> representante):
    id = representante['id'],
    nombres = representante['nombres'],
    apellidos = representante['apellidos'],
    cedula = representante['Cedula'],
    numero = representante['Numero'],
    ubicacion = representante['Ubicacion'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'nombres':nombres,
    'apellidos':apellidos,
    'cedula':cedula,
    'numero':numero,
    'ubicacion':ubicacion
  }:{
    'nombres':nombres,
    'apellidos':apellidos,
    'cedula':cedula,
    'numero':numero,
    'ubicacion':ubicacion
  };

}