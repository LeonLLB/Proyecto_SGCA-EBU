import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DateTimePicker.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/FichaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';

class FichaEstudiante extends StatefulWidget {
  @override
  State<FichaEstudiante> createState() => _FichaEstudianteState();
}

enum _genero {e,M,F}
enum _tipo {e,Regular,Repitiente}
enum _procedencia {e,Hogar,Institucion}
enum _parentesco {e,Padre,Madre,Tutor}
enum _casoTabla {invisible,recordFicha,Boletin}

class _FichaEstudianteState extends State<FichaEstudiante> {

  TextEditingController controladorConsulta = TextEditingController();
  bool modoEditar = false;

  _genero generoEstudiante = _genero.e;
  _tipo tipoEstudiante = _tipo.e;
  _procedencia procedenciaEstudiante = _procedencia.e;
  _parentesco parentesco = _parentesco.e;
  _casoTabla casoTablaVisualizar = _casoTabla.invisible;

  Map<String, dynamic> controladoresEstudiante = {
    'Nombres':TextEditingController(),
    'Apellidos':TextEditingController(),
    'LugarNacimiento':TextEditingController(),
    'EstadoNacimiento':TextEditingController(),
    'Cedula':TextEditingController(),
    'FechaNacimiento':'',
    'Genero':''    
  };

  Map<String, dynamic> controladoresFicha = {
    'Talla':TextEditingController(),
    'Peso':TextEditingController(),
    'FechaInscripcion':'',
    'Tipo':'',
    'Procedencia':'',
    'Alergia':false,
    'Asma':false,
    'Cardiaco':false,
    'Tipaje':false,
    'Respiratorio':false,
    'Detalles':'',
  };

  TextEditingController controladorCedulaRepresentante = TextEditingController();

  final _formKeyConsulta = GlobalKey<FormState>();
  final _formKeyEstudiante = GlobalKey<FormState>();

  Future<Map<String,Object?>?> fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(null);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width * (6/10) - 200;
    final double width2 = MediaQuery.of(context).size.width * (5.2/9) - 200;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          Form(
            key: _formKeyConsulta,
            child: Center(
              child: SimplifiedContainer(            
                width: width,
                child:Row(
                  children: [
                    SimplifiedTextFormField(
                      controlador: controladorConsulta,
                      labelText: 'Cedula escolar',
                      validators: TextFormFieldValidators(required:true,isNumeric:true),  
                    ),
                  VerticalDivider(),
                  TextButton.icon(
                    onPressed: (){
                      fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(int.parse(controladorConsulta.text));
                      setState((){});
                    },
                    icon: Icon(Icons.search),
                    label: Text('Buscar')
                  )
                ])
              )
            )
          ),
          Padding(padding:EdgeInsets.symmetric(vertical:5)),
          FutureBuilder(
            future: fichaEstudiante,
            builder: (BuildContext context, AsyncSnapshot data) {
              if(data.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
              }
              else if(data.data == null){
                return Center(child:Text('No hubo resultados, esto puede deberse a que no haya ambientes inscritos, no haya una matricula de docentes para ese ambiente, o no haya estudiantes en el aula solicitada'));
              }
              else{
                controladoresEstudiante = {
                  'Nombres':TextEditingController(text: data.data['nombres']),
                  'Apellidos':TextEditingController(text: data.data['apellidos']),
                  'LugarNacimiento':TextEditingController(text: data.data['lugar_nacimiento']),
                  'EstadoNacimiento':TextEditingController(text: data.data['estado_nacimiento']),
                  'FechaNacimiento':data.data['fecha_nacimiento'],
                  'Cedula':TextEditingController(text:data.data['cedula'].toString()),
                  'Genero':data.data['genero'],                  
                };

                controladoresFicha = {
                  'Talla':TextEditingController(text: data.data['talla'].toString()),
                  'Peso':TextEditingController(text: data.data['peso'].toString()),
                  'FechaInscripcion':data.data['fecha_inscripcion'],
                  'Tipo':data.data['tipo_estudiante'],
                  'Procedencia':data.data['procendencia'],
                  'Alergia':(data.data['alergia'] == 1),
                  'Asma':(data.data['asma'] == 1),
                  'Cardiaco':(data.data['cardiaco'] == 1),
                  'Tipaje':(data.data['tipaje'] == 1),
                  'Respiratorio':(data.data['respiratorio'] == 1),
                  'Detalles':data.data['detalles'],
                };

                controladorCedulaRepresentante.text=data.data['r.cedula'].toString();

                (data.data['genero'] == 'F') ? generoEstudiante = _genero.F : generoEstudiante = _genero.M ;
                (data.data['tipo_estudiante'] == 'Repitiente') ? tipoEstudiante = _tipo.Repitiente : tipoEstudiante = _tipo.Regular ;
                (data.data['procendencia'] == 'Hogar') ? procedenciaEstudiante = _procedencia.Hogar : procedenciaEstudiante = _procedencia.Institucion ;
                if(data.data['r.parentesco'] != null){
                  switch(data.data['r.parentesco']){
                    case 'Padre':
                      parentesco = _parentesco.Padre;
                      break;
                    case 'Madre':
                      parentesco = _parentesco.Madre;
                      break;
                    case 'Tutor':
                      parentesco = _parentesco.Tutor;
                      break;
                    default:
                    parentesco = _parentesco.e;
                      break;
                  }
                }

                return Form(
                  key: _formKeyEstudiante,
                  child: Column(children:[
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                      SimplifiedContainer(
                        width:width2,
                        height:200,
                        child: SingleChildScrollView(
                          child: Column(children:[
                            Center(
                              child:Text('Información del estudiante:',
                            style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
                            )),
                          DoubleTextFormFields(
                              controladores: [
                                controladoresEstudiante['Nombres'],
                                controladoresEstudiante['Apellidos']
                              ],
                              iconos: [Icon(Icons.face)],
                              labelTexts: ['Nombres','Apellidos'],
                              validators: [
                                TextFormFieldValidators(required:true,isNotNumeric:true),
                                TextFormFieldValidators(required:true,isNotNumeric:true)
                              ],
                              enabled:modoEditar,
                            ),
                          DoubleTextFormFields(
                              controladores: [
                                controladoresEstudiante['LugarNacimiento'],
                                controladoresEstudiante['EstadoNacimiento']
                              ],
                              iconos: [Icon(Icons.location_on)],
                              labelTexts: ['Lugar de nacimiento','Estado de nacimiento'],
                              validators: [
                                TextFormFieldValidators(required:true),
                                TextFormFieldValidators(required:true,isNotNumeric:true)
                              ],
                              enabled:modoEditar,
                            ),
                            Row(
                              children: [
                                SimplifiedTextFormField(
                                  controlador: controladoresEstudiante['Cedula'],
                                  labelText: 'Cedula escolar',
                                  enabled:modoEditar,
                                  validators: TextFormFieldValidators(required:true,isNumeric: true,charLength: 13)
                                ),
                              ],
                            ),
                            Padding(padding:EdgeInsets.symmetric(vertical:5)),
                            DateTimePicker(onChange: (fecha){
                                final newDate = fecha!.toIso8601String().split('T')[0].split('-');
                                controladoresEstudiante['FechaNacimiento'] = '${newDate[2]}/${newDate[1]}/${newDate[0]}';
                                setState((){});
                              },
                              defaultText: 'Fecha de Nacimiento',
                              maxDate:DateTime(DateTime.now().year - 6,12,31),
                              lastDate: controladoresEstudiante['FechaNacimiento'],
                              defaultDate:DateTime(DateTime.now().year - 6),
                              enabled:modoEditar
                            ),
                            Padding(padding:EdgeInsets.symmetric(vertical:5)),
                            Center(child:Text('Genero',style:TextStyle(fontSize:18))),
                            RadioInputRowList<_genero>(
                              groupValue: generoEstudiante,
                              values: [_genero.e,_genero.M,_genero.F],
                              labels: ['','Masculino','Femenino'],
                              ignoreFirst:true,
                              enabled:modoEditar,
                              onChanged: (val){
                                setState(() {
                                  controladoresEstudiante['Genero'] = val.toString().split('.')[1];
                                  generoEstudiante = val!;
                                });
                              }
                            ),
                            Padding(padding:EdgeInsets.symmetric(vertical:5)),
                            Center(child:Text('Tipo de estudiante',style:TextStyle(fontSize:18))),
                            RadioInputRowList<_tipo>(
                              groupValue: tipoEstudiante,
                              values: [_tipo.e,_tipo.Regular,_tipo.Repitiente],
                              labels: ['','Regular','Repitiente'],
                              ignoreFirst:true,
                              enabled:modoEditar,
                              onChanged: (val){
                                setState(() {
                                  controladoresFicha['Tipo'] = val.toString().split('.')[1];
                                  tipoEstudiante = val!;
                                });
                              }
                            ),
                            Padding(padding:EdgeInsets.symmetric(vertical:5)),
                            Center(child:Text('Viene del:',style:TextStyle(fontSize:18))),
                            RadioInputRowList<_procedencia>(
                              groupValue: procedenciaEstudiante,
                              values: [_procedencia.e,_procedencia.Hogar,_procedencia.Institucion],
                              labels: ['','Hogar','Institución'],
                              ignoreFirst:true,
                              enabled:modoEditar,
                              onChanged: (val){
                                setState(() {
                                  controladoresFicha['Procedencia'] = val.toString().split('.')[1];
                                  procedenciaEstudiante = val!;                                  
                                });
                              }
                            ),
                          ]),
                        )
                      ),
                      SimplifiedContainer(
                        width:width2,
                        height:200,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Center(
                              child:Text('Información del representante:',
                            style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
                            )),
                            Row(
                              children: [
                                SimplifiedTextFormField(
                                  controlador: controladorCedulaRepresentante,
                                  labelText: 'Cedula representante',
                                  validators: TextFormFieldValidators(required:true,isNumeric:true,charLength:9)
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                              children:[
                              Text(data.data['r.nombres']),
                              Text(data.data['r.apellidos'])
                            ]),
                            Text(data.data['r.numero']),
                            Text(data.data['r.ubicacion']),
                            RadioInputRowList<_parentesco>(
                              groupValue: parentesco,
                              values: [_parentesco.e,_parentesco.Padre,_parentesco.Madre,_parentesco.Tutor],
                              labels: ['','Padre','Madre','Tutor'],
                              ignoreFirst:true,
                              onChanged: (val){
                                parentesco = val!;
                                setState((){});
                              }
                            ),
                            Padding(padding:EdgeInsets.symmetric(vertical:5)),
                            ElevatedButton(onPressed: ()async{
                              final viejoRepresentante = Representante(
                                nombres: data.data['r.nombres'],
                                apellidos: data.data['r.apellidos'],
                                cedula: data.data['r.cedula'],
                                numero: data.data['r.numero'],
                                ubicacion: data.data['r.ubicacion']
                              );
                              final confirmacion = await confirmarCambioRepresentante(
                                viejoRepresentante,
                                int.parse(controladorCedulaRepresentante.text),
                              context);
                              if(confirmacion != null && confirmacion){
                                ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                                  message: 'Cambiando el representante...',
                                  onVisible:()async{
                                    try {
                                      await controladorEstudiante.cambiarRepresentante(data.data['e.id'], parentesco.toString().split('.')[1], int.parse(controladorCedulaRepresentante.text));
                                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Representante cambiado con exito!'));
                                      fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(int.parse(controladorConsulta.text));
                                      setState((){});
                                    } catch (e) {
                                      print(e);
                                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al cambiar el representante'));
                                    }
                                  }
                                ));
                              }
                          }, child: Text('Cambiar representante'))
                          ]),
                        )
                      )
                    ]),
                    Padding(padding:EdgeInsets.symmetric(vertical:5)),
                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                      SimplifiedContainer(
                        width:width2,
                        height:200,
                        child: SingleChildScrollView(child:Column(children:[
                          Center(
                            child:Text('Detalles del estudiante:',
                          style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
                          )),
                          DoubleTextFormFields(
                            controladores: [
                              controladoresFicha['Peso'],
                              controladoresFicha['Talla']
                            ],
                            enabled:modoEditar,
                            iconos: [Icon(Icons.face)],
                            labelTexts: ['Peso','Talla'],
                            validators: [
                              TextFormFieldValidators(required:true,isDouble:true),
                              TextFormFieldValidators(required:true,isDouble:true)
                            ]
                          ),
                          Center(child:Text('Posee alergias?')),
                          RadioInputRowList<bool>(enabled:modoEditar,groupValue: controladoresFicha['Alergia'], values: [true,false], labels: ['Si','No'], onChanged: (val){
                            controladoresFicha['alergia'] = val!;
                          }),
                          Center(child:Text('Es asmatico?')),
                          RadioInputRowList<bool>(enabled:modoEditar,groupValue: controladoresFicha['Asma'], values: [true,false], labels: ['Si','No'], onChanged: (val){
                            controladoresFicha['asma'] = val!;
                          }),
                          Center(child:Text('Tiene problemas cardiacos?')),
                          RadioInputRowList<bool>(enabled:modoEditar,groupValue: controladoresFicha['Cardiaco'], values: [true,false], labels: ['Si','No'], onChanged: (val){
                            controladoresFicha['cardiaco'] = val!;
                          }),
                          Center(child:Text('Tipaje?')),
                          RadioInputRowList<bool>(enabled:modoEditar,groupValue: controladoresFicha['Tipaje'], values: [true,false], labels: ['Si','No'], onChanged: (val){
                            controladoresFicha['tipaje'] = val!;
                          }),
                          Center(child:Text('Tiene problemas respiratios?')),
                          RadioInputRowList<bool>(enabled:modoEditar,groupValue: controladoresFicha['Respiratorio'], values: [true,false], labels: ['Si','No'], onChanged: (val){
                            controladoresFicha['respiratorio'] = val!;
                          }),
                          Container(
                            height:100,
                            child:TextField(
                              decoration: InputDecoration(
                                labelText: 'Detalles'                      
                              ),
                              enabled:modoEditar,
                              maxLines:null,
                              controller: controladoresFicha['detalles'],
                              expands:true
                            )
                          )
                        ]))
                      ),
                      SimplifiedContainer(
                        width:width2,
                        height:200,
                        child: SingleChildScrollView(child:Column(children:[
                          Center(
                            child:Text('Matricula actual:',
                          style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
                          )),
                          Text(data.data['añoEscolar'] == null ? 'No esta inscrito al año actual!' : 'Año escolar: ${data.data['añoEscolar']}'),                  
                          Text(data.data['añoEscolar'] == null ? '' : 'Aula: ${data.data['grado']}° \"${data.data['seccion']}\"'),   

                          //TODO: INCLUIR AL DOCENTE EN LA FICHA (Y EL TURNO)
                          Padding(padding:EdgeInsets.symmetric(vertical:5)),
                          ElevatedButton(onPressed: (){}, child: Text('Cambiar o asignar matricula'))
                        ]))
                      ),
                    ])
                    ,Padding(padding:EdgeInsets.symmetric(vertical:5)),
                    RadioInputRowList<_casoTabla>(
                      groupValue: casoTablaVisualizar,
                      values: [_casoTabla.invisible,_casoTabla.recordFicha,_casoTabla.Boletin],
                      labels: ['Cerrar tablas','Ver record de ficha','Ver record estudiantil'],
                      onChanged: (val){
                        casoTablaVisualizar = val!;
                        setState((){});
                      }
                    )
                  ]),
                );
              }
            },
          ),
          Padding(padding:EdgeInsets.symmetric(vertical:5)),
        ]),
      ),
    );
  }

  Future<bool?> confirmarCambioRepresentante(
    Representante representanteViejo,
    int cedulaRepresentanteNuevo,
    BuildContext context
  )async{
    
      final Representante? representante = await controladorRepresentante.buscarRepresentante(cedulaRepresentanteNuevo);
      if(representante == null){
        ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No existe el representante solicitado'));
        return false;
      }
      else{
        return showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirmar cambios'),
            content: SingleChildScrollView(
              child: Center(
                child: ListBody(
                  children: [
                    Center(child: Text('Antiguo representante:',style:TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('${representanteViejo.nombres} ${representanteViejo.apellidos}',style:TextStyle(fontWeight: FontWeight.bold))),
                    Center(
                      child: Row(children: [
                        Text('C.I: ',style:TextStyle(fontWeight: FontWeight.bold)),
                        Text(representanteViejo.cedula.toString())
                      ]),
                    ),
                    Center(child: Text('Nuevo representante:',style:TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('${representante.nombres} ${representante.apellidos}',style:TextStyle(fontWeight: FontWeight.bold))),
                    Center(
                      child: Row(children: [
                        Text('C.I: ',style:TextStyle(fontWeight: FontWeight.bold)),
                        Text(representante.cedula.toString())
                      ]),
                    ),
                  ],
                ),
              )
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );
      }
    }
}