import 'package:proyecto_sgca_ebu/models/Representantes.dart';
import 'package:proyecto_sgca_ebu/providers/SupabaseClient.dart';

class _RepresentanteControllers extends Client {
  Future<Representante?> obtenerRepresentantePorCedula(int cedula) async {
    final response = await client
        .from('Representantes')
        .select('Nombres, Apellidos, Numero, Direccion')
        .eq('Cedula', cedula)
        .execute();

    return Representante.fromJson(response.data);
  }
}

final controlesRepresentantes = _RepresentanteControllers();
