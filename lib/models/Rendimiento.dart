

class Rendimiento {

  static final String obtenerRendimientosSegunMatriculaYAmbiente = '''
  
  SELECT
    r.id,
    r.matricula_estudianteID,
    r.aprobado
  FROM Ambientes am
  LEFT OUTER JOIN Matricula_Estudiantes me
    ON me.ambienteID = am.id
  LEFT OUTER JOIN Rendimiento r
    ON r.matricula_estudianteID = me.id
  WHERE am.id = ?;
  
  ''';

  static final String tableName = "Rendimiento";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      matricula_estudianteID INTEGER UNIQUE NOT NULL,
      aprobado BOOL DEFAULT false,

      FOREIGN KEY (matricula_estudianteID) REFERENCES Matricula_Estudiantes (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
    );
  
  ''';

  int? id;
  int matriculaEstudianteID;
  bool aprobado;

  Rendimiento({
    this.id,
    required this.matriculaEstudianteID,
    required this.aprobado
  });

  Rendimiento.fromForm(Map<String,dynamic> rendimiento) :
    matriculaEstudianteID = rendimiento['MatEstudianteID'],
    aprobado = rendimiento['Aprobado']
  ;

  Rendimiento.fromMap(Map<String,dynamic> rendimiento) :
    id = rendimiento['id'],
    matriculaEstudianteID = rendimiento['matricula_estudianteID'],
    aprobado = rendimiento['aprobado'] == 1
  ;

  Map<String,dynamic> toJson({bool withId = true}) => (withId) ? {
    'id' : id,
    'matricula_estudianteID' : matriculaEstudianteID,
    'aprobado' : (aprobado)  ? 1 : 0
  } : {
    'matricula_estudianteID' : matriculaEstudianteID,
    'aprobado' : (aprobado)  ? 1 : 0
  };

}