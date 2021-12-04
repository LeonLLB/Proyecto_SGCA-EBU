import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_sgca_ebu/controllers/Egresados.dart';
import 'package:proyecto_sgca_ebu/controllers/Estadistica.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Record.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
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

Future<bool> generarBoletinR(int egresadoID) async{

  final pw.Document doc = pw.Document(); 

  final cintillo = pw.MemoryImage(
    (await rootBundle.load('assets/Cintillo pdf.png')).buffer.asUint8List()
  ); 

  final egresado = await controladorEgresados.buscarEgresadoPorIDR(egresadoID,false);
  final records = await controladorRecord.obtenerRecordsDeEgresadoR(egresadoID);

  final plantilla = pw.MultiPage(
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
                child:pw.Text('BOLETIN ESTUDIANTIL',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Center(
                child:pw.Text('FECHA DE GRADUACION: ${egresado!.fechaGraduacion}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Center(
                child:pw.Text('${egresado.estudiante['nombres']} ${egresado.estudiante['apellidos']} C.E: ${egresado.estudiante['cedula']}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:10)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['Rendimiento','Grado y Seccion','Año Escolar','Fecha de Inscripcion'],
                  ...records!.map((record) => [
                    (record.aprobado)?'Aprobado':'Reprobado',
                    '${record.gradoCursado}° "${record.seccionCursada}"',
                    record.yearEscolar,
                    record.fechaInscripcion
                  ]).toList()
                ]
              ),
            ]
          )
        )];
      }
    );

    doc.addPage(plantilla);
  try {
    Directory? directorio = await getDownloadsDirectory();
    String path = directorio!.path + '/sgca_ebu documentos/';
    if(await Directory(path).exists() != true){
      new Directory(path).createSync(recursive: true);
      final File archivo = File(path + "Boletin egresado ${egresado!.estudiante['nombres']} ${egresado.estudiante['apellidos']} ${egresado.estudiante['cedula']} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    } else {
      final File archivo = File(path + "Boletin egresado ${egresado!.estudiante['nombres']} ${egresado.estudiante['apellidos']} ${egresado.estudiante['cedula']} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }

}

Future<bool> generarDocumentoMatriculaEstudiantes(int ambienteID) async {
  
  final pw.Document doc = pw.Document(); 

  final cintillo = pw.MemoryImage(
    (await rootBundle.load('assets/Cintillo pdf.png')).buffer.asUint8List()
  );
  
  List<Map<String,Object?>>? matricula = await controladorMatriculaEstudiante.getMatricula(ambienteID);

  final plantilla = pw.MultiPage(
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
          pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:5)),
          pw.Center(
          child: pw.Column(
            children:[
              pw.Center(
                child:pw.Text('MATRICULA DE ${matricula![0]['grado']}° "${matricula[0]['seccion']}" TURNO: ${(matricula[0]['turno'] == 'M') ? 'Mañana' : 'Tarde'} AÑO ESCOLAR: ${matricula[0]['añoEscolar']}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:5)),
              pw.Center(
                child:pw.Text('DOCENTE: ${matricula[0]['docente.nombres']} ${matricula[0]['docente.apellidos']} ESTUDIANTES: ${matricula[0]['CantidadEstudiantes']}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:5)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['Nombres','Apellidos','Cedula Escolar','Fecha de Nacimiento','Edad'],
                  ...matricula.map((estudiante)=>[
                    estudiante['estudiante.nombres'],
                    estudiante['estudiante.apellidos'],
                    estudiante['cedula'],
                    estudiante['fecha_nacimiento'],
                    calcularEdad(estudiante['fecha_nacimiento']).toString()  + ' años'
                  ])
                ]
              ),
            ]
          )
        )];
      }
    );

    doc.addPage(plantilla);
  try {
    Directory? directorio = await getDownloadsDirectory();
    String path = directorio!.path + '/sgca_ebu documentos/';
    if(await Directory(path).exists() != true){
      new Directory(path).createSync(recursive: true);
      final File archivo = File(path + "Matrícula ${matricula![0]['grado']}° ${matricula[0]['seccion']} ${matricula[0]['añoEscolar']} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    } else {
      final File archivo = File(path + "Matrícula ${matricula![0]['grado']}° ${matricula[0]['seccion']} ${matricula[0]['añoEscolar']} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }

}

Future<bool> generarDocumentoEstadistica(int ambienteID, int mes)async{

  final pw.Document doc = pw.Document(); 

  final cintillo = pw.MemoryImage(
    (await rootBundle.load('assets/Cintillo pdf.png')).buffer.asUint8List()
  ); 

  final ambiente = await controladorAmbientes.obtenerAmbientePorID(ambienteID,false);
  final resultsMatricula = await controladorEstadistica.getMatricula(ambienteID,mes,false);
  final resultsClasificacion = await controladorEstadistica.getClasificacionEdadSexo(ambienteID,false);
  final resultsAsistencia = await controladorEstadistica.getAsistencia(ambienteID, mes);


  final plantilla = pw.MultiPage(
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
          pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
          pw.Center(
          child: pw.Column(
            children:[
              pw.Center(
                child:pw.Text('ESTADISTICA DE ${ambiente!.grado}° "${ambiente.seccion}" MES: ${monthNumIntoString(mes)}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Center(
                child:pw.Text('Estadística de la matrícula',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['','Varones','Hembras','Total'],
                  ['Días habiles',resultsMatricula!['Dias Habiles']!['V'],resultsMatricula['Dias Habiles']!['V'],resultsMatricula['Dias Habiles']!['V']],
                  ['Matrícula',resultsMatricula['Matricula']!['V'],resultsMatricula['Matricula']!['H'],resultsMatricula['Matricula']!['T']],
                  ['1° Día del mes',resultsMatricula['1° Dia']!['V'],resultsMatricula['1° Dia']!['H'],resultsMatricula['1° Dia']!['T']],
                  ['Egresos',resultsMatricula['Egresos']!['V'],resultsMatricula['Egresos']!['H'],resultsMatricula['Egresos']!['T']],
                  ['Ingresos',resultsMatricula['Ingresos']!['V'],resultsMatricula['Ingresos']!['H'],resultsMatricula['Ingresos']!['T']],
                  ['Matrícula final',resultsMatricula['Matricula Final']!['V'],resultsMatricula['Matricula Final']!['H'],resultsMatricula['Matricula Final']!['T']],
                ]
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Center(
                child:pw.Text('Clasificación por edad y sexo',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['Edad','Varones','Hembras','Total'],
                  ...resultsClasificacion![0].map((clafGeneral) => [
                    (clafGeneral['edad'] == null) ? 'TOTAL' : clafGeneral['edad'],
                    (clafGeneral['edad'] == null) ? clafGeneral['TV'] : clafGeneral['V'],
                    (clafGeneral['edad'] == null) ? clafGeneral['TH'] : clafGeneral['H'],
                    (clafGeneral['edad'] == null) ? clafGeneral['TT'] : clafGeneral['T']
                  ]).toList()
                ]
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Center(
                child:pw.Text('Clasificación de los repitientes',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['Edad','Varones','Hembras','Total'],
                  ...resultsClasificacion[1].map((clafGeneral) => [
                    (clafGeneral['edad'] == null) ? 'TOTAL' : clafGeneral['edad'],
                    (clafGeneral['edad'] == null) ? clafGeneral['TV'] : clafGeneral['V'],
                    (clafGeneral['edad'] == null) ? clafGeneral['TH'] : clafGeneral['H'],
                    (clafGeneral['edad'] == null) ? clafGeneral['TT'] : clafGeneral['T']
                  ]).toList()
                ]
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Center(
                child:pw.Text('Estadística de la asistencia',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:1)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['','Varones','Hembras','Total'],
                  ['Total de asistencias',resultsAsistencia!['Total']!['V'],resultsAsistencia['Total']!['H'],resultsAsistencia['Total']!['T']],
                  ['Media',resultsAsistencia['Media']!['V'].toStringAsFixed(2),resultsAsistencia['Media']!['H'].toStringAsFixed(2),resultsAsistencia['Media']!['T'].toStringAsFixed(2)],
                  ['Porcentaje',
                    ((resultsAsistencia['Porcentaje']!['V'].toStringAsFixed(2) == 'NaN') ? '0.00' : resultsAsistencia['Porcentaje']!['V'].toStringAsFixed(2)) + '%',
                    ((resultsAsistencia['Porcentaje']!['H'].toStringAsFixed(2) == 'NaN') ? '0.00' : resultsAsistencia['Porcentaje']!['H'].toStringAsFixed(2)) + '%',
                    ((resultsAsistencia['Porcentaje']!['T'].toStringAsFixed(2) == 'NaN') ? '0.00' : resultsAsistencia['Porcentaje']!['T'].toStringAsFixed(2)) + '%'
                  ],
                ]
              ),
            ]
          )
        )];
      }
    );

    doc.addPage(plantilla);
  try {
    Directory? directorio = await getDownloadsDirectory();
    String path = directorio!.path + '/sgca_ebu documentos/';
    if(await Directory(path).exists() != true){
      new Directory(path).createSync(recursive: true);
      final File archivo = File(path + "Estadistica ${ambiente!.grado}° ${ambiente.seccion} ${monthNumIntoString(mes)} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    } else {
      final File archivo = File(path + "Estadistica ${ambiente!.grado}° ${ambiente.seccion} ${monthNumIntoString(mes)} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }

}

Future<bool> generarBoletin(int estudianteID) async{

  final pw.Document doc = pw.Document(); 

  final cintillo = pw.MemoryImage(
    (await rootBundle.load('assets/Cintillo pdf.png')).buffer.asUint8List()
  ); 

  final estudiante = await controladorEstudiante.buscarEstudiantePorID(estudianteID);
  final records = await controladorRecord.obtenerRecordsDeEstudiante(estudianteID);

  final plantilla = pw.MultiPage(
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
                child:pw.Text('BOLETIN ESTUDIANTIL',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Center(
                child:pw.Text('${estudiante!.nombres} ${estudiante.apellidos} C.E: ${estudiante.cedula}',
                style:pw.TextStyle(fontWeight:pw.FontWeight.bold,decoration: pw.TextDecoration.underline))
              ),
              pw.Padding(padding:pw.EdgeInsets.symmetric(vertical:10)),
              pw.Table.fromTextArray(
                border: pw.TableBorder(horizontalInside: pw.BorderSide()),
                data: [
                  ['Rendimiento','Grado y Seccion','Año Escolar','Fecha de Inscripcion'],
                  ...records!.map((record) => [
                    (record.aprobado)?'Aprobado':'Reprobado',
                    '${record.gradoCursado}° "${record.seccionCursada}"',
                    record.yearEscolar,
                    record.fechaInscripcion
                  ]).toList()
                ]
              ),
            ]
          )
        )];
      }
    );

    doc.addPage(plantilla);
  try {
    Directory? directorio = await getDownloadsDirectory();
    String path = directorio!.path + '/sgca_ebu documentos/';
    if(await Directory(path).exists() != true){
      new Directory(path).createSync(recursive: true);
      final File archivo = File(path + "Boletin ${estudiante!.nombres} ${estudiante.apellidos} ${estudiante.cedula} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    } else {
      final File archivo = File(path + "Boletin ${estudiante!.nombres} ${estudiante.apellidos} ${estudiante.cedula} ${DateTime.now().toIso8601String().split('T')[0]}.pdf");
      archivo.writeAsBytesSync(await doc.save());
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }

}
