

class EstudianteURepresentante{

  static String consultarUnionEuRuMEuAM(int? cedula,int? cedula2,String type){
    if(type == 'E'){
      return '''
      
      SELECT 
        e.id AS "estudiante.id",
        e.nombres AS "estudiante.nombres",
        e.apellidos AS "estudiante.apellidos",
        e.cedula AS "estudiante.cedula",
        e.fecha_nacimiento AS "estudiante.fecha_nacimiento",
        r.id AS "representante.id",
        r.nombres AS "representante.nombres",
        r.apellidos AS "representante.apellidos",
        r.cedula AS "representante.cedula",
        me.id AS "Matricula.id",
        me."añoEscolar",
        am.grado,
        am.seccion
      FROM   Informacion_estudiantes e

      LEFT OUTER JOIN Estudiante_U_Representante u
        ON e.id = u.estudianteID

      LEFT OUTER JOIN Representantes r
        ON u.representanteID = r.id
        
      LEFT OUTER JOIN Matricula_Estudiantes me
        ON me.estudianteID = u.estudianteID
        
      LEFT OUTER JOIN Ambientes am
        ON am.id = me.ambienteID

      WHERE CAST(e.cedula AS TEXT) LIKE '%$cedula%';
      
      ''';
    }else if(type == 'R'){
      return '''
      
      SELECT 
        e.id AS "estudiante.id",
        e.nombres AS "estudiante.nombres",
        e.apellidos AS "estudiante.apellidos",
        e.cedula AS "estudiante.cedula",
        e.fecha_nacimiento AS "estudiante.fecha_nacimiento",
        r.id AS "representante.id",
        r.nombres AS "representante.nombres",
        r.apellidos AS "representante.apellidos",
        r.cedula AS "representante.cedula",
        me.id AS "Matricula.id",
        me."añoEscolar",
        am.grado,
        am.seccion
      FROM   Informacion_estudiantes e

      LEFT OUTER JOIN Estudiante_U_Representante u
        ON e.id = u.estudianteID

      LEFT OUTER JOIN Representantes r
        ON u.representanteID = r.id
        
      LEFT OUTER JOIN Matricula_Estudiantes me
        ON me.estudianteID = u.estudianteID
        
      LEFT OUTER JOIN Ambientes am
        ON am.id = me.ambienteID

      WHERE CAST(r.cedula AS TEXT) LIKE '%$cedula%';
      
      ''';
    }else if(type == 'ALL'){
      return '''
      
      SELECT 
        e.id AS "estudiante.id",
        e.nombres AS "estudiante.nombres",
        e.apellidos AS "estudiante.apellidos",
        e.cedula AS "estudiante.cedula",
        e.fecha_nacimiento AS "estudiante.fecha_nacimiento",
        r.id AS "representante.id",
        r.nombres AS "representante.nombres",
        r.apellidos AS "representante.apellidos",
        r.cedula AS "representante.cedula",
        me.id AS "Matricula.id",
        me."añoEscolar",
        am.grado,
        am.seccion
      FROM   Informacion_estudiantes e

      LEFT OUTER JOIN Estudiante_U_Representante u
        ON e.id = u.estudianteID

      LEFT OUTER JOIN Representantes r
        ON u.representanteID = r.id
        
      LEFT OUTER JOIN Matricula_Estudiantes me
        ON me.estudianteID = u.estudianteID
        
      LEFT OUTER JOIN Ambientes am
        ON am.id = me.ambienteID

      WHERE CAST(e.cedula AS TEXT) LIKE '%%' AND CAST(r.cedula AS TEXT) LIKE '%%';
      
      ''';
    }else{      
      return '''
      
      SELECT 
        e.id AS "estudiante.id",
        e.nombres AS "estudiante.nombres",
        e.apellidos AS "estudiante.apellidos",
        e.cedula AS "estudiante.cedula",
        e.fecha_nacimiento AS "estudiante.fecha_nacimiento",
        r.id AS "representante.id",
        r.nombres AS "representante.nombres",
        r.apellidos AS "representante.apellidos",
        r.cedula AS "representante.cedula",
        me.id AS "Matricula.id",
        me."añoEscolar",
        am.grado,
        am.seccion
      FROM   Informacion_estudiantes e

      LEFT OUTER JOIN Estudiante_U_Representante u
        ON e.id = u.estudianteID

      LEFT OUTER JOIN Representantes r
        ON u.representanteID = r.id
        
      LEFT OUTER JOIN Matricula_Estudiantes me
        ON me.estudianteID = u.estudianteID
        
      LEFT OUTER JOIN Ambientes am
        ON am.id = me.ambienteID

      WHERE CAST(e.cedula AS TEXT) LIKE '%$cedula%' AND CAST(r.cedula AS TEXT) LIKE '%$cedula2%';
      
      ''';
    }
  }

  static final String tableName = "Estudiante_U_Representante";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Estudiante_U_Representante(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL,
      representanteID INTEGER NOT NULL,
      
      FOREIGN KEY (estudianteID) REFERENCES Estudiante (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
      
      FOREIGN KEY (representanteID) REFERENCES Representante (id)
      	ON UPDATE CASCADE
      	ON DELETE CASCADE
    );
  
  ''';
}