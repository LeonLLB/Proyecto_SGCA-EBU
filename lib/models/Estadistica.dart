

class Estadistica{

  static final String getEstudiantesParaClasificacionEdadSexo = '''
  
  SELECT
    e.id AS 'estudiante.id',
    e.genero,
	  fe.tipo_estudiante,
    e.fecha_nacimiento
  FROM Matricula_Estudiantes me
  LEFT OUTER JOIN Informacion_estudiantes e
    ON me.estudianteID = e.id
  LEFT OUTER JOIN Ambientes am
    ON am.id = me.ambienteID
  LEFT OUTER JOIN Ficha_Estudiante fe
	  ON fe.estudianteID = e.id
  WHERE am.id = ?;
  
  ''';

}