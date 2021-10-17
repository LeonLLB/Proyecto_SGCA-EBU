

class EstudianteURepresentante{
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