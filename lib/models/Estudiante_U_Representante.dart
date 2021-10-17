

class EstudianteURepresentante{
  static final String tableName = "Estudiante_U_Representante";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Estudiante_U_Representante(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      estudianteID INTEGER NOT NULL REFERENCES Informacion_estudiantes
        ON DELETE CASCADE
        ON UPDATE CASCADE,
      representanteID INTEGER NOT NULL REFERENCES Representantes
        ON DELETE CASCADE
        ON UPDATE CASCADE,,
    );
  
  ''';
}