CREATE TABLE Usuarios(
		id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nombres VARCHAR(20) NOT NULL, 
      apellidos VARCHAR(20) NOT NULL,
      cedula INT UNIQUE NOT NULL,
      contraseña VARCHAR(255) NOT NULL,
      correo VARCHAR(50) ,
      numero VARCHAR(11),
      direccion VARCHAR(30),
      rol CHAR(1) NOT NULL
    );