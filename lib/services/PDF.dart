import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';

Future<bool> generarConstanciaEstudianteCompleta(Map<String,Object?> estudiante) async {
  final pw.Document doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context){
        return pw.Center(
          child: pw.Column(
            children:[
              pw.Text('${estudiante["estudiante.nombres"]} ${estudiante["estudiante.apellidos"]}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
              pw.Row(children: [
                pw.Row(children: [
                  pw.Text('C.E: ',style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                  pw.Text(estudiante['estudiante.cedula'].toString()),
                ]),
                pw.Text(calcularEdad(estudiante["estudiante.fecha_nacimiento"]).toString() + ' años')
              ],mainAxisAlignment:pw.MainAxisAlignment.spaceEvenly),
              pw.Row(children: [
                pw.Text(estudiante['añoEscolar'] as String),
                pw.Text(estudiante['grado'].toString() + '"${estudiante['seccion']}"')
              ],mainAxisAlignment:pw.MainAxisAlignment.spaceEvenly),
              pw.Text('${estudiante["representante.nombres"]} ${estudiante["representante.apellidos"]}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
              pw.Row(children: [
                pw.Text('C.I: ',style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                pw.Text(estudiante['representante.cedula'].toString()),
              ]),
            ]
          )
        );
      }
    )
  );

  try {
    Directory? directorio = await getDownloadsDirectory();
    String path = directorio!.path + '/sgca_ebu documentos/';
    if(await Directory(path).exists() != true){
      new Directory(path).createSync(recursive: true);
      final File archivo = File(path + "Constancia ${estudiante['estudiante.nombres']} ${estudiante['estudiante.apellidos']} ${estudiante['estudiante.cedula']} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    } else {
      final File archivo = File(path + "Constancia ${estudiante['estudiante.nombres']} ${estudiante['estudiante.apellidos']} ${estudiante['estudiante.cedula']} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }

}

Future<bool> imprimirConstanciaEstudianteCompleta(Map<String,Object?> estudiante) async {
  final pw.Document doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context){
        return pw.Center(
          child: pw.Column(
            children:[
              pw.Text('${estudiante["estudiante.nombres"]} ${estudiante["estudiante.apellidos"]}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
              pw.Row(children: [
                pw.Row(children: [
                  pw.Text('C.E: ',style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                  pw.Text(estudiante['estudiante.cedula'].toString()),
                ]),
                pw.Text(calcularEdad(estudiante["estudiante.fecha_nacimiento"]).toString() + ' años')
              ],mainAxisAlignment:pw.MainAxisAlignment.spaceEvenly),
              pw.Row(children: [
                pw.Text(estudiante['añoEscolar'] as String),
                pw.Text(estudiante['grado'].toString() + '"${estudiante['seccion']}"')
              ],mainAxisAlignment:pw.MainAxisAlignment.spaceEvenly),
              pw.Text('${estudiante["representante.nombres"]} ${estudiante["representante.apellidos"]}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
              pw.Row(children: [
                pw.Text('C.I: ',style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                pw.Text(estudiante['representante.cedula'].toString()),
              ]),
            ]
          )
        );
      }
    )
  );

  try {
    final impreso = await Printing.layoutPdf(onLayout: (_) async => await doc.save());
    return impreso;
  } catch (e) {
    print(e);
    return false;
  }

}
