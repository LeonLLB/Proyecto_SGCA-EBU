import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Rendimiento.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Rendimiento.dart';

class SubirRendimientoEstudiante extends StatefulWidget {

  @override
  State<SubirRendimientoEstudiante> createState() => _SubirRendimientoEstudianteState();
}

class _SubirRendimientoEstudianteState extends State<SubirRendimientoEstudiante> {

  Ambiente? ambiente;

  List<Map<String,Object?>>? matriculaSeleccionada = [];

  List<Rendimiento> listaRendimiento = [];

  Future<List<Map<String,Object?>>?> changer() async {
    
    listaRendimiento = [];
    if(matriculaSeleccionada != null && matriculaSeleccionada!.length > 0){
      
      for(var matricula in matriculaSeleccionada!){
        await controladorRendimiento.buscarRendimiento(matricula['id'] as int)
        .then((rendimiento){
          if(rendimiento != null){
            listaRendimiento.add(rendimiento);
          }else{
            listaRendimiento.add(Rendimiento(
              matriculaEstudianteID: matricula['id'] as int,
              aprobado: false
            ));
          }
        });
      }

      return matriculaSeleccionada;
    
    }else{
      return null;
    }


  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child:Column(
          children: [
            AmbientePicker(onChange: (ambienteSeleccionado)async{
              ambiente = ambienteSeleccionado;
              matriculaSeleccionada = await controladorMatriculaEstudiante.getMatricula(ambiente!.id);
              

              setState((){});
            }),
            Padding(padding:EdgeInsets.symmetric(vertical: 5)),
            FutureBuilder(
              future: changer(),
              builder: (BuildContext context, AsyncSnapshot data) {
                if(data.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else if(data.data == null || data.data[0]['docente.nombres'] == null){
                  return Center(child:Text('No hubo resultados, esto puede deberse a que no haya ambientes inscritos, no haya una matricula de docentes para ese ambiente, o no haya estudiantes en el aula solicitada'));
                }
                else{
                  return Column(children: [
                    SimplifiedContainer(child: Column(children: [
                      Text(data.data[0]['docente.nombres'] + ' ' + data.data[0]['docente.apellidos'] ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children:[
                          Text(data.data[0]['añoEscolar']),
                          Row(children: [
                            Text(data.data[0]['grado'].toString()+'° '),
                            Text('\"'+data.data[0]['seccion']+'\"'),
                          ])
                        ]
                      ),
                      Text('Total de estudiantes: ${data.data[0]['CantidadEstudiantes']}'),
                      Text('Turno: ${(data.data[0]['turno'] == 'M') ? 'Mañana' : 'Tarde'}'),

                    ])),
                    Padding(padding:EdgeInsets.symmetric(vertical: 5)),                  
                    Table(
                      //border: TableBorder.all(),
                      border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                      children:[
                        TableRow(
                          children:[
                            TableCell(
                              child:  Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(child: Text('Nombres')),
                              )
                            ),
                            TableCell(
                              child:  Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(child: Text('Apellidos')),
                              )
                            ),
                            TableCell(
                              child:  Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(child:Text('Rendimiento del año escolar\n${data.data[0]['añoEscolar']}')),
                              )
                            ),
                          ]
                        ),
                        ...data.data.asMap().entries.map((estudiante)=>TableRow(
                          children:[
                            TableCell(
                              child:  Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(child: Text(estudiante.value['estudiante.nombres'])),
                              )
                            ),
                            TableCell(
                              child:  Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(child: Text(estudiante.value['estudiante.apellidos'])),
                              )
                            ),
                            _TableCellRadioInputRow(
                              rendimiento: listaRendimiento[estudiante.key],
                              onChange: (val){
                                listaRendimiento[estudiante.key].aprobado = val!;
                              }
                            ),
                          ]
                        )).toList()
                      ]
                    ),
                    Padding(padding:EdgeInsets.symmetric(vertical: 5)), 
                    ElevatedButton(
                      onPressed: ()async{
                        final bool? confirmar = await confirmarSubida(context);
                        if(confirmar != null && confirmar){
                          subirRendimiento(context);
                        }
                      },
                      child: Text('Subir asistencia')
                    ),
                    Padding(padding:EdgeInsets.symmetric(vertical: 5))
                  ]);
                }
              },
            ),
          ]
        )
      )
    );
  }

  Future<bool?> confirmarSubida(BuildContext context)=>showDialog(
    context: context, builder: (BuildContext context)=>AlertDialog(
      title:Text('Confirmar cambio de rendimiento'),
      content:(Text('Estas a punto de cambiar el rendimiento de los estudiantes de este ambiente, una vez cambie el año escolar, no se podran hacer modificaciones a los rendimientos.')),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirmar'),
        ),
      ]
    )
  );

  void subirRendimiento(BuildContext context) {
    List<int> resultados = [];
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message: 'Subiendo rendimientos...',
      onVisible:()async{
        try {
          final results = await controladorRendimiento.registrarRendimientos(listaRendimiento);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
          resultados.addAll(results);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al subir uno de los rendimientos'));  
        }
        if(resultados.length > 0){
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se han subido o actualizado varios rendimientos'));  
        }
      }
      )
    );
  }
}

class _TableCellRadioInputRow extends StatefulWidget {

  final void Function(bool?) onChange;
  final Rendimiento rendimiento;
  
  _TableCellRadioInputRow({
    required this.onChange,
    required this.rendimiento
  });

  @override
  State<_TableCellRadioInputRow> createState() => _TableCellRadioInputRowState();
}

class _TableCellRadioInputRowState extends State<_TableCellRadioInputRow> {
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child:  Padding(
        padding: EdgeInsets.all(5),                               
        child: RadioInputRowList<bool>(
          groupValue: widget.rendimiento.aprobado,
          values: [true,false],
          labels: ['Aprobado','Reprobado'],
          onChanged: (val){
            widget.rendimiento.aprobado = val!;
            widget.onChange(val);
            setState((){});
          }
        )
      )
    );
  }
}