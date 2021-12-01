

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
      estado_nacimiento VARCHAR(30) NOT NULL,
      fecha_nacimiento VARCHAR(10) NOT NULL,
      genero CHAR(1) NOT NULL
    );
  
  ''';

  int? id;
  String nombres;
  String apellidos;
  int cedula;
  String lugarNacimiento;
  String estadoNacimiento;
  DateTime fechaNacimiento;
  String genero;

  Estudiante({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.lugarNacimiento,
    required this.estadoNacimiento,
    required this.fechaNacimiento,
    required this.genero
  });

  Estudiante.fromForm(Map<String,dynamic> estudiante) :
    id = estudiante['id'] == null ? null : estudiante['id'],
    nombres = estudiante['Nombres'],
    apellidos = estudiante['Apellidos'],
    cedula = (estudiante['Cedula'].runtimeType == int) ? estudiante['Cedula'] : int.parse(estudiante['Cedula']) ,
    lugarNacimiento = estudiante['LugarNacimiento'],
    estadoNacimiento = estudiante['EstadoNacimiento'],
    fechaNacimiento = DateTime(int.parse(estudiante['FechaNacimiento'].split('/')[2]),int.parse(estudiante['FechaNacimiento'].split('/')[1]),int.parse(estudiante['FechaNacimiento'].split('/')[0])),
    genero = estudiante['Genero'];

  Estudiante.fromMap(Map<String,dynamic> estudiante):
    id = estudiante['id'],
    nombres = estudiante['nombres'],
    apellidos = estudiante['apellidos'],
    cedula = estudiante['cedula'],
    lugarNacimiento = estudiante['lugar_nacimiento'],
    estadoNacimiento = estudiante['estado_nacimiento'],
    fechaNacimiento = DateTime(int.parse(estudiante['fecha_nacimiento'].split('/')[2]),int.parse(estudiante['fecha_nacimiento'].split('/')[1]),int.parse(estudiante['fecha_nacimiento'].split('/')[0])),
    genero = estudiante['genero'];

  Map<String,dynamic> toJson({bool withId = true})=>(withId)?{
    'id':id,
    'nombres':nombres,
    'apellidos':apellidos,
    'cedula':cedula,
    'lugar_nacimiento':lugarNacimiento,
    'estado_nacimiento':estadoNacimiento,
    'fecha_nacimiento':'${fechaNacimiento.toIso8601String().split('T')[0].split('-')[2]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[1]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[0]}',
    'genero':genero,
  }:{
    'nombres':nombres,
    'apellidos':apellidos,
    'cedula':cedula,
    'lugar_nacimiento':lugarNacimiento,
    'estado_nacimiento':estadoNacimiento,
    'fecha_nacimiento':'${fechaNacimiento.toIso8601String().split('T')[0].split('-')[2]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[1]}/${fechaNacimiento.toIso8601String().split('T')[0].split('-')[0]}',
    'genero':genero,
  };

}