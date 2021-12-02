

class EgresadoRespaldado{

  static final String tableName = 'EgresadosR';

  static final String testInitializer = 'SELECT id FROM $tableName';

  static final String tableInitializer = '''
  
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY NOT NULL,
    estudiante_nombres VARCHAR(20) NOT NULL,
    estudiante_apellidos VARCHAR(20) NOT NULL,
    estudiante_cedula INTEGER NOT NULL,
    estudiante_fecha_nacimiento VARCHAR(10) NOT NULL,    
    estudiante_genero VARCHAR(1) NOT NULL,
    estudiante_edad_al_graduarse INTEGER NOT NULL,
    estudiante_lugar_nacimiento VARCHAR(30) NOT NULL,
    estudiante_estado_nacimiento VARCHAR(30) NOT NULL,
    representante_nombres VARCHAR(20) NOT NULL,
    representante_apellidos VARCHAR(20) NOT NULL,
    representante_cedula INTEGER NOT NULL,
    grado INTEGER NOT NULL,
    seccion VARCHAR(1) NOT NULL,
    añoEscolarCursado VARCHAR(9) NOT NULL,
    fechaGraduacion VARCHAR(10) NOT NULL
  );
  
  ''';

  int? id;
  Map<String,dynamic> estudiante;
  Map<String,dynamic> representante;
  int grado;
  String seccion;
  String yearEscolarCursado;
  String fechaGraduacion;

  EgresadoRespaldado({
    this.id,
    required this.grado,
    required this.seccion,
    required this.yearEscolarCursado,
    required this.fechaGraduacion,
    required this.estudiante,
    required this.representante
  }){
    assert(this.estudiante['nombres'] != null, "Es necesario el campo 'nombres' en estudiante");
    assert(this.estudiante['apellidos'] != null, "Es necesario el campo 'apellidos' en estudiante");
    assert(this.estudiante['cedula'] != null, "Es necesario el campo 'cedula' en estudiante");
    assert(this.estudiante['fecha_nacimiento'] != null, "Es necesario el campo 'fecha_nacimiento' en estudiante");
    assert(this.estudiante['genero'] != null, "Es necesario el campo 'genero' en estudiante");
    assert(this.estudiante['edad_al_graduarse'] != null, "Es necesario el campo 'edad_al_graduarse' en estudiante");
    assert(this.estudiante['lugar_nacimiento'] != null, "Es necesario el campo 'lugar_nacimiento' en estudiante");
    assert(this.estudiante['estado_nacimiento'] != null, "Es necesario el campo 'estado_nacimiento' en estudiante");

    assert(this.representante['nombres'] != null , "Es necesario el campo 'nombres' en representante");
    assert(this.representante['apellidos'] != null , "Es necesario el campo 'apellidos' en representante");
    assert(this.representante['cedula'] != null , "Es necesario el campo 'cedula' en representante");
  }

  EgresadoRespaldado.fromMap(Map<String,dynamic> egresadoInfo) : 
    id = egresadoInfo['id'],
    grado = egresadoInfo['grado'],
    seccion = egresadoInfo['seccion'],
    yearEscolarCursado = egresadoInfo['añoEscolarCursado'],
    fechaGraduacion = egresadoInfo['fechaGraduacion'],
    estudiante = {
      'nombres' : egresadoInfo['estudiante_nombres'],
      'apellidos' : egresadoInfo['estudiante_apellidos'],
      'cedula' : egresadoInfo['estudiante_cedula'],
      'fecha_nacimiento' : egresadoInfo['estudiante_fecha_nacimiento'],
      'genero' : egresadoInfo['estudiante_genero'],
      'edad_al_graduarse' : egresadoInfo['estudiante_edad_al_graduarse'],
      'lugar_nacimiento' : egresadoInfo['estudiante_lugar_nacimiento'],
      'estado_nacimiento' : egresadoInfo['estudiante_estado_nacimiento']
    },
    representante = {
      'nombres': egresadoInfo['representante_nombres'],
      'apellidos': egresadoInfo['representante_apellidos'],
      'cedula': egresadoInfo['representante_cedula']
    };

  Map<String,dynamic> toJson([bool withId = true]) => (withId) ? {
    'id' : id,
    'estudiante_nombres' : estudiante['nombres'],
    'estudiante_apellidos' : estudiante['apellidos'],
    'estudiante_cedula' : estudiante['cedula'],
    'estudiante_fecha_nacimiento' : estudiante['fecha_nacimiento'],
    'estudiante_genero' : estudiante['genero'],
    'estudiante_edad_al_graduarse' : estudiante['edad_al_graduarse'],
    'estudiante_lugar_nacimiento' : estudiante['lugar_nacimiento'],
    'estudiante_estado_nacimiento' : estudiante['estado_nacimiento'],
    'representante_nombres' : representante['nombres'],
    'representante_apellidos' : representante['apellidos'],
    'representante_cedula' : representante['cedula'],
    'grado' : grado,
    'seccion' : seccion,
    'añoEscolarCursado' : yearEscolarCursado,
    'fechaGraduacion' : fechaGraduacion
  } : {
    'estudiante_nombres' : estudiante['nombres'],
    'estudiante_apellidos' : estudiante['apellidos'],
    'estudiante_cedula' : estudiante['cedula'],
    'estudiante_fecha_nacimiento' : estudiante['fecha_nacimiento'],
    'estudiante_genero' : estudiante['genero'],
    'estudiante_edad_al_graduarse' : estudiante['edad_al_graduarse'],
    'estudiante_lugar_nacimiento' : estudiante['lugar_nacimiento'],
    'estudiante_estado_nacimiento' : estudiante['estado_nacimiento'],
    'representante_nombres' : representante['nombres'],
    'representante_apellidos' : representante['apellidos'],
    'representante_cedula' : representante['cedula'],
    'grado' : grado,
    'seccion' : seccion,
    'añoEscolarCursado' : yearEscolarCursado,
    'fechaGraduacion' : fechaGraduacion
  } ;

}