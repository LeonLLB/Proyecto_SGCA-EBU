

class Egresado {

  static final String tableName='Egresados';

  static final String testInitializer='SELECT id FROM $tableName';

  static final String tableInitializer='''
  
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    estudianteID INTEGER NOT NULL,
    representanteID INTEGER NOT NULL,
    grado INTEGER NOT NULL,
    seccion VARCHAR(1) NOT NULL,
    añoEscolarCursado VARCHAR(9) NOT NULL,

    FOREIGN KEY (representanteID) REFERENCES Representantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

    FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes  (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
  );
  
  ''';

  static final String consultarPosiblesEgresados = '''
  
  SELECT 
    rbe.estudianteID,
    rbe.gradoCursado AS 'grado',
    rbe.seccionCursada AS 'seccion',
    rbe.'añoEscolar' AS 'añoEscolarCursado',
    eur.representanteID
  FROM Record_Boletin_Estudiantil rbe
  LEFT OUTER JOIN Estudiante_U_Representante eur
    ON eur.estudianteID = rbe.estudianteID
  WHERE rbe.gradoCursado = 6 AND rbe.aprobado = 1;
  
  ''';

  int? id;
  int estudianteID;
  int representanteID;
  int grado;
  String seccion;
  String yearEscolarCursado;

   Egresado({
     this.id,
     required this.estudianteID,
     required this.representanteID,
     required this.grado,
     required this.seccion,
     required this.yearEscolarCursado
   });

  Egresado.fromMap(Map<String,dynamic> egresado) : 
    id = egresado['id'],
    estudianteID = egresado['estudianteID'],
    representanteID = egresado['representanteID'],
    grado = egresado['grado'],
    seccion = egresado['seccion'],
    yearEscolarCursado = egresado['añoEscolarCursado'];

  Map<String,dynamic> toJson([withId = true]) => (withId) ? {
    'id':id,
    'estudianteID': estudianteID,
    'representanteID': representanteID,
    'grado': grado,
    'seccion': seccion,
    'añoEscolarCursado': yearEscolarCursado,
  } : {
    'estudianteID': estudianteID,
    'representanteID': representanteID,
    'grado': grado,
    'seccion': seccion,
    'añoEscolarCursado': yearEscolarCursado,
  };

}