import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_sgca_ebu/helpers/getMonth.dart';
import 'package:proyecto_sgca_ebu/models/Usuarios.dart';

Future<pw.MultiPage> planillaConstancia(Map<String,Object?> estudiante,Usuarios director,String genero)async{

  final cintillo = pw.MemoryImage(
    (await rootBundle.load('assets/Cintillo pdf.png')).buffer.asUint8List()
  ); 

  final today = DateTime.now();

  return pw.MultiPage(
      header:(pw.Context context){
        return pw.Column(children: [
          pw.Image(cintillo),
          pw.Row(
            mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GRUPO ESCOLAR \"URIAPARA\"',style:pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('COD. DEA OD05711012',style:pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]
          )
        ]) ;
      },
      footer:(pw.Context context){
        return pw.Center(
          child:pw.Text('Dirección: Calle Prolongación Bolivar, Sector La Puente frente a la redoma, TLF: 0287752325 Barrancas del Orinoco',
            style:pw.TextStyle(fontSize: 8)
          )
        );
      },
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context){
        return [
          pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:65)),
          pw.Center(
          child: pw.Column(
            children:[
              pw.Center(
                child:pw.Text('CONSTANCIA DE ESTUDIO',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:10)),
              pw.Paragraph(style:pw.TextStyle(lineSpacing: 12,),text: '           ${genero == 'F' ? 'La Suscrita Directora' : 'El Suscrito Director'} del Grupo Escolar \"Uriapara\", que funciona en Barrancas del Orinoco, Municipio Sotillo del Estado Monagas, por medio de la presente CERTIFICA, que el alumno (a): ${estudiante['estudiante.nombres']} ${estudiante['estudiante.apellidos']} nacido(a) el ${estudiante['estudiante.fecha_nacimiento']}, Natural de ${estudiante['estudiante.lugar_nacimiento']} Estado ${estudiante['estudiante.estado_nacimiento']} esta inscrito en esta institución para cursar el ${estudiante['grado']}° de Educación Primaria: año Escolar: ${estudiante['añoEscolar']}.'),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:5)),
              pw.Paragraph(style:pw.TextStyle(lineSpacing: 12,),text: '           Se expide la siguinte constancia a solicitud de parte interesada en Barrancas del Orinoco a los ${today.day} días del mes de ${monthNumIntoString(today.month)} del año ${today.year}.'),
              pw.Padding(padding: pw.EdgeInsets.symmetric(vertical:15)),
              pw.Center(
                child:pw.Text('Atentamente,',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold))
              ),
              pw.Padding(padding: pw.EdgeInsets.symmetric(vertical:37)),
              pw.Center(
                child:pw.Column(children: [
                  pw.Text('MSc. ${director.nombres.split(' ')[0]} ${director.apellidos.split(' ')[0]}',
                    style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration:pw.TextDecoration.overline)),
                  pw.Text((genero == 'F' ? 'DIRECTORA' : 'DIRECTOR'),
                    style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                  pw.Text('C.I. N° V-${director.cedula}',
                    style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                  pw.Text('Telf. ${director.numero}',
                    style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
                ])
              )
            ]
          )
        )];
      }
    );
}

Future<bool> generarConstanciaEstudianteCompleta(Map<String,Object?> estudiante,Usuarios director,String genero) async {
  final pw.Document doc = pw.Document();
  
  doc.addPage(await planillaConstancia(estudiante, director, genero));

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

Future<bool> imprimirConstanciaEstudianteCompleta(Map<String,Object?> estudiante,Usuarios director,String genero) async {
  final pw.Document doc = pw.Document(); 
  
  
  doc.addPage(await planillaConstancia(estudiante, director, genero));

  try {
    final impreso = await Printing.layoutPdf(onLayout: (_) async => await doc.save());
    return impreso;
  } catch (e) {
    print(e);
    return false;
  }

}
