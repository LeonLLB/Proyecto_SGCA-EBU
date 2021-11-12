class Asistencia{

  static final String tableName='Asistencia_mensual';

  static final String testInitializer='SELECT id FROM $tableName';

  static final String tableInitializer='''
  
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      asistencias VARCHAR(92) NOT NULL,
      mes INTEGER NOT NULL,
      añoEscolar VARCHAR(9),

      FOREIGN KEY (estudianteID) REFERENCES Informacion_estudiantes  (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE

      UNIQUE(mes,añoEscolar,estudianteID)
    );
  
  ''';

  static final String getAsistenciasPorAmbiente = '''
  
    SELECT
      asis.id,
      asis.mes,
      asis.asistencias,
      asis.estudianteID
    FROM Asistencia_mensual asis
    LEFT OUTER JOIN Matricula_Estudiantes me
      ON asis.estudianteID = me.estudianteID
    LEFT OUTER JOIN Ambientes am
      ON me.ambienteID = am.id
    WHERE am.id = ? AND asis.mes = ?;

  ''';

  static final String getAsistenciasPorAmbienteEnBaseAMatricula = '''
  
    SELECT
      asis.id,
      asis.mes,
      asis.asistencias,
      me.estudianteID
    FROM Matricula_Estudiantes me 
    LEFT OUTER JOIN Asistencia_mensual asis
      ON asis.estudianteID = me.estudianteID
      AND asis.mes = ?
    LEFT OUTER JOIN Ambientes am
      ON me.ambienteID = am.id
    WHERE am.id = ?;
  
  ''';

  int? id;
  int estudianteID;
  List<int> asistencias;
  int mes;

  static List<int> _turnAsistenciasIntoList(String asistencias){
    final List<String> asistenciasSeparadas = asistencias.split(',');
    final List<int> listaDiasAsistencias = asistenciasSeparadas.map((asistencia)=>int.parse(asistencia)).toList();
    return listaDiasAsistencias;
  }

  Asistencia({
    this.id,
    required this.estudianteID,
    required this.asistencias,
    required this.mes
  });

  Asistencia.fromForm(Map<String,dynamic> asistencia) :
    estudianteID = asistencia['EstudianteID'],
    asistencias = asistencia['Asistencias'],
    mes = asistencia['Mes'];
  
  Asistencia.fromMap(Map<String,dynamic> asistencia) :
    id = asistencia['id'],
    estudianteID = asistencia['estudianteID'],
    asistencias = _turnAsistenciasIntoList(asistencia['asistencias']),
    mes = asistencia['mes'];

  Map<String,dynamic> toJson({bool withId = true,bool simplified = true})=>(withId)?{
    'id':id,
    'estudianteID' : estudianteID,
    'asistencias' : (simplified) ? asistencias.join(',') : asistencias,
    'mes' : mes
  }:{
    'estudianteID' : estudianteID,
    'asistencias' : (simplified) ? asistencias.join(',') : asistencias,
    'mes' : mes
  };

}