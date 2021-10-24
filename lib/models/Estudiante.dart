

class Estudiante{
  
  static final String tableName = "Informacion_estudiantes";

  static final String testInitializer = "SELECT id FROM Informacion_estudiantes";

  static final String tableInitializer = '''
  
    CREATE TABLE Informacion_estudiantes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nombres VARCHAR(20) NOT NULL, 
      apellidos VARCHAR(20) NOT NULL,
      cedula INTEGER UNIQUE NOT NULL,
      lugar_nacimiento VARCHAR(30) NOT NULL,
      fecha_nacimiento VARCHAR(10) NOT NULL,
      genero CHAR(1) NOT NULL
    );
  
  ''';

  int? id;
  String nombres;
  String apellidos;
  int cedula;
  String lugarNacimiento;
  DateTime fechaNacimiento;
  String genero;

  Estudiante({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.lugarNacimiento,
    required this.fechaNacimiento,
    required this.genero
  });

  Estudiante.fromForm(Map<String,dynamic> estudiante) :
    nombres = estudiante['Nombres'],
    apellidos = estudiante['Apellidos'],
    cedula = estudiante['Cedula'],
    lugarNacimiento = estudiante['LugarNacimiento'],
    fechaNacimiento = DateTime(int.parse(estudiante['FechaNacimiento'].split('/')[2]),int.parse(estudiante['FechaNacimiento'].split('/')[1]),int.parse(estudiante['FechaNacimiento'].split('/')[0])),
    genero = estudiante['Genero'];

  Estudiante.fromMap(Map<String,dynamic> estudiante):
    id = estudiante['id'],
    nombres = estudiante['nombres'],
    apellidos = estudiante['apellidos'],
    cedula = estudiante['cedula'],
    lugarNacimiento = estudiante['lugar_nacimiento'],
    fechaNacimiento = DateTime(estudiante['fecha_nacimiento'].split('/')[2],estudiante['FechaNacimiento'].split('/')[1],estudiante['FechaNacimiento'].split('/')[0]),
    genero = estudiante['genero'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'nombres':nombres,
    'apellidos':apellidos,
    'cedula':cedula,
    'lugar_nacimiento':lugarNacimiento,
    'fecha_nacimiento':'${fechaNacimiento.toIso8601String().split('T')[0].split('-')[2]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[1]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[0]}',
    'genero':genero,
  }:{
    'nombres':nombres,
    'apellidos':apellidos,
    'cedula':cedula,
    'lugar_nacimiento':lugarNacimiento,
    'fecha_nacimiento':'${fechaNacimiento.toIso8601String().split('T')[0].split('-')[2]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[1]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[0]}',
    'genero':genero,
  };

}