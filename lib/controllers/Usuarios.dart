import 'package:proyecto_sgca_ebu/providers/SupabaseClient.dart';

class UsuariosController extends Client {
  void registroUsuarioPersonal() {}

  bool estaAutenticado() => client.auth.user() != null;

  void iniciarSesion() {}
}
