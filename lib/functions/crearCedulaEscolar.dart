import 'package:proyecto_sgca_ebu/providers/SupabaseClient.dart';

class _CedulaEscolarCreator extends Client {
  Future<String> func(String cedulaRepresentante, int inscripcionYear) async {
    //PASO 1: CUANTOS ESTUDIANTES ESTAN INSCRITOS, EN EL MISMO AÑO, POR EL MISMO REPRESENTANTE
    final response = await client
        .from('Estudiantes')
        .select('id')
        .like('Cedula', '%${inscripcionYear - 2000}$cedulaRepresentante%')
        .execute();

    if (response.status! < 300) {
      return '${response.count! + 1}{$inscripcionYear-2000}$cedulaRepresentante';
    } else {
      return 'ERROR';
    }
  }
}

final _ = _CedulaEscolarCreator();

Future<String> crearCedulaEscolar(
    String cedulaRepresentante, int inscripcionYear) async {
  return await _.func(cedulaRepresentante, inscripcionYear);
}
