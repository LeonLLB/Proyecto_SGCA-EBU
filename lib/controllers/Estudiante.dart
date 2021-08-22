import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Representantes.dart';
import 'package:proyecto_sgca_ebu/providers/SupabaseClient.dart';

class _EstudianteController extends Client {
  Future<Map<String, dynamic>> inscribirInicial(
      Estudiante estudiante, Representante representante) async {
    final responseEstudiante =
        client.from('Estudiantes').insert(estudiante.toJsonData()).execute();

    final responseRepresentante =
        client.from('Representante').insert(representante.toJson()).execute();

    return await responseEstudiante.then((valorEstudiante) {
      return responseRepresentante.then((valorRepresentante) async {
        if (valorEstudiante.status! < 300 && valorRepresentante.status! < 300) {
          final valorUnion = await client
              .from('Representantes_U_Estudiantes')
              .insert({}).execute();
          return {
            'status': [
              valorEstudiante.status,
              valorRepresentante.status,
              valorUnion.status
            ],
            'data': [
              valorEstudiante.data,
              valorRepresentante.data,
              valorUnion.data
            ]
          };
        } else {
          return {
            'status': [valorEstudiante.status, valorRepresentante.status],
            'error': {
              'codigos': [
                valorEstudiante.error?.code,
                valorRepresentante.error?.code
              ],
              'msg': [
                valorEstudiante.error?.message,
                valorRepresentante.error?.message
              ]
            }
          };
        }
      });
    });
  }
}

final _EstudianteController controlesEstudiante = _EstudianteController();
