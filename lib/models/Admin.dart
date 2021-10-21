

class Admin {
  static final String tableName = "Admin_Options";

  static final String testInitializer = "SELECT id FROM $tableName";

  static final String tableInitializer = '''
  
    CREATE TABLE Admin_Options(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      opcion VARCHAR(20) UNIQUE NOT NULL,
      valor VARCHAR(20) NOT NULL 
    );
  
  ''';

  int? id;
  String opcion;
  String valor;

  Admin({this.id,required this.opcion, required this.valor});

  Admin.fromForm(Map<String,String> opciones) :
    opcion = opciones['Opción']!,
    valor = opciones['Valor']!;

  Admin.fromMap(Map<String,dynamic> opciones) :
    id = opciones['id'],
    opcion = opciones['opcion'],
    valor = opciones['valor'];
  
  Map<String, dynamic> toJson({withId: true}) => (!withId) ? {
    'opcion' : opcion,
    'valor' : valor,
  } : {
    'id':id,
    'opcion' : opcion,
    'valor' : valor,
  };
}