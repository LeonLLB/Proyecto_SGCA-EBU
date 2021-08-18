import 'package:proyecto_sgca_ebu/models/Usuarios.dart';
import 'package:proyecto_sgca_ebu/providers/SupabaseClient.dart';

class UsuariosController extends Client {
  void registroUsuarioPersonal(Usuario usuario) {}

  bool estaAutenticado() => client.auth.user() != null;

  void iniciarSesion() {}
}
