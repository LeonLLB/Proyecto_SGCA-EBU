import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DateTimePicker.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/snackbars.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/FichaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Ficha_Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';

class FichaEstudiantePage extends StatefulWidget {
  @override
  State<FichaEstudiantePage> createState() => _FichaEstudiantePageState();
}

enum _genero {e,M,F}
enum _tipo {e,Regular,Repitiente}
enum _procedencia {e,Hogar,Institucion}
enum _parentesco {e,Padre,Madre,Tutor}
enum _casoTabla {invisible,recordFicha,Boletin}

class _FichaEstudiantePageState extends State<FichaEstudiantePage> {

  TextEditingController controladorConsulta = TextEditingController();
  bool modoEditar = false;

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
                  'id':data.data['e.id'],
                  'Nombres':TextEditingController(text: data.data['nombres']),
                  'Apellidos':TextEditingController(text: data.data['apellidos']),
                  'LugarNacimiento':TextEditingController(text: data.data['lugar_nacimiento']),
                  'EstadoNacimiento':TextEditingController(text: data.data['estado_nacimiento']),
                  'FechaNacimiento':data.data['fecha_nacimiento'],
                  'Cedula':TextEditingController(text:data.data['cedula'].toString()),
                  'Genero':data.data['genero'],                  
                };

                controladoresFicha = {
                  'id':data.data['id'],
                  'EstudianteID':data.data['e.id'],
                  'Talla':TextEditingController(text: data.data['talla'].toString()),
                  'Peso':TextEditingController(text: data.data['peso'].toString()),
                  'FechaInscripcion':data.data['fecha_inscripcion'],
                  'Tipo':data.data['tipo_estudiante'],
                  'Procedencia':data.data['procedencia'],
                  'Alergia':(data.data['alergia'] == 1),
                  'Asma':(data.data['asma'] == 1),
                  'Cardiaco':(data.data['cardiaco'] == 1),
                  'Tipaje':(data.data['tipaje'] == 1),
                  'Respiratorio':(data.data['respiratorio'] == 1),
                  'Detalles':TextEditingController(text:data.data['detalles']),
                };

                controladorCedulaRepresentante.text=data.data['r.cedula'].toString();
                
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
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children:[
                        ElevatedButton.icon(
                          onPressed: (){
                            if(!modoEditar){
                              modoEditar=true;
                              ScaffoldMessenger.of(context).showSnackBar(simpleSnackbar('El modo de actualización fue activado, al presionar de nuevo se actualizara la información'));
                              setState((){});
                            }else{
                              //TODA LA LOGICA
                              ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                                message:'Actualizando al estudiante y su ficha...',
                                onVisible:()async{
                                  try {
                                    await controladorEstudiante.modificarEstudiante(Estudiante.fromForm(formInfoIntoMap(controladoresEstudiante)), FichaEstudiante.fromForm(formInfoIntoMap(controladoresFicha)));
                                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El estudiante y su ficha fueron modificados!'));
                                    modoEditar=false;
                                    fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(int.parse(controladorConsulta.text));
                                    setState((){});
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                    if(e.toString().contains('UNIQUE constraint')){
                                      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Uno de los campos ya estan en la base de datos y no se pueden repetir'));
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se ha podido actualizar al estudiante o la ficha'));
                                    }
                                  }
                                }
                              ));
                            }
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Actualizar estudiante')
                        ),
                        ElevatedButton.icon(
                          style:ElevatedButton.styleFrom(primary:Colors.red),
                          onPressed: ()async{
                            final confirmacion = await confirmarEliminacion(context);
                            if(confirmacion != null && confirmacion){
                              try {
                                await controladorEstudiante.eliminarEstudiante(controladoresEstudiante['id']);
                                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Estudiante eliminado con exito'));
                                fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(null);
                                controladorConsulta.text = '';
                                setState((){});
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al eliminar el estudiante'));
                              }
                            }
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Eliminar estudiante')
                        )
                      ]
                    ),
                    Padding(padding:EdgeInsets.symmetric(vertical:5)),
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
                            _CamposStatefulParteEstudiante(
                              infoEstudiante: {
                                ...controladoresEstudiante,
                                'FechaInscripcion':controladoresFicha['FechaInscripcion'],
                                'Tipo':controladoresFicha['Tipo'],
                                'Procedencia':controladoresFicha['Procedencia'],
                              },
                              enabled: modoEditar,
                              onCaseChange: (changeCase, value){
                                switch(changeCase){
                                  case 1:
                                  //MODIFICACION DE LA FECHA DE NACIMIENTO
                                    final newDate = (value as DateTime).toIso8601String().split('T')[0].split('-');
                                    controladoresEstudiante['FechaNacimiento'] = '${newDate[2]}/${newDate[1]}/${newDate[0]}';
                                    break;
                                  case 2:
                                  //MODIFICACION DEL GENERO
                                    final _genero val = value;
                                    controladoresEstudiante['Genero'] = val.toString().split('.')[1];
                                    break;
                                  case 3:
                                  //MODIFICACION DEL TIPO
                                    final _tipo val = value;
                                    controladoresFicha['Tipo'] = val.toString().split('.')[1];
                                    break;
                                  case 4:
                                  //MODIFICACION DE LA PROCEDENCIA
                                    final _procedencia val = value;
                                    controladoresFicha['Procedencia'] = val.toString().split('.')[1];
                                    break;
                                  case 5:
                                  //MODIFICACION DE LA FECHA DE INSCRIPCION
                                    final newDate = (value as DateTime).toIso8601String().split('T')[0].split('-');
                                    controladoresFicha['FechaInscripcion'] = '${newDate[2]}/${newDate[1]}/${newDate[0]}';
                                    break;
                                }
                              }
                            )
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
                            _CamposStatefulParteRepresentante(
                              onChange: (val){parentesco=val;},
                              parentescoDefault: parentesco
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
                          _CamposStatefulParteDetalles(
                            infoFicha: controladoresFicha,
                            enabled: modoEditar,
                            onCaseChange: (caseChange, value){
                              switch(caseChange){
                                case 1:
                                  //SE MODIFICO LO DE LA ALERGIA
                                  controladoresFicha['Alergia'] = value;
                                  break;
                                case 2:
                                  // SE MODIFICO LO DEL ASMA
                                  controladoresFicha['Asma'] = value;
                                  break;
                                case 3:
                                  // SE MODIFICO LO DE CARDIACIO
                                  controladoresFicha['Cardiaco'] = value;
                                  break;
                                case 4:
                                  // SE MODIFICO LO DEL TIPAJE
                                  controladoresFicha['Tipaje'] = value;
                                  break;
                                case 5:
                                  // SE MODIFICO LO DE RESPIRATORIO
                                  controladoresFicha['Respiratorio'] = value;
                                  break;
                              }
                            }
                          ),
                          Container(
                            height:100,
                            child:TextField(
                              decoration: InputDecoration(
                                labelText: 'Detalles'                      
                              ),
                              enabled:modoEditar,
                              maxLines:null,
                              controller: controladoresFicha['Detalles'],
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
                          Text(data.data['añoEscolar'] == null ? '' : 'Turno: ${data.data['turno']}'),   
                          Text((data.data['añoEscolar'] != null && data.data['d.nombres'] != null) ? 'Docente: ${data.data['d.nombres']} ${data.data['d.apellidos']}' : ''),   
                          Text((data.data['añoEscolar'] != null && data.data['d.nombres'] != null) ? 'C.I: ${data.data['d.cedula']}' : ''),   

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
  
   Future<bool?> confirmarEliminacion(
    BuildContext context
  )async{
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: SingleChildScrollView(
          child: Center(
            child: ListBody(
              children: [
                Icon(Icons.warning,color:Colors.red,size:72),                  
                Wrap(
                  children:[
                  Text('Estas seguro de querer eliminar este estudiante? Toda información que tenga que ver con el mismo sera eliminada de manera permanente, se recomienda respaldar su boletín u otros datos primero',
                    style:TextStyle(color:Colors.red)
                  )
                ])
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
            style:ElevatedButton.styleFrom(primary:Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _CamposStatefulParteEstudiante extends StatefulWidget {

  final void Function(int changeCase, dynamic val) onCaseChange;
  final bool enabled;
  final Map<String,dynamic> infoEstudiante;
  //1: Fecha Nacimiento 2: Genero 3: Tipo 4: Procedencia 5: Fecha Inscripcion

  _CamposStatefulParteEstudiante({required this.infoEstudiante,required this.onCaseChange, required this.enabled});

  @override
  __CamposStatefulParteEstudianteState createState() => __CamposStatefulParteEstudianteState(infoEstudiante:infoEstudiante);
}

class __CamposStatefulParteEstudianteState extends State<_CamposStatefulParteEstudiante> {
  
  Map<String,dynamic> infoEstudiante;
  _genero generoEstudiante = _genero.e;
  _tipo tipoEstudiante = _tipo.e;
  _procedencia procedenciaEstudiante = _procedencia.e;

  __CamposStatefulParteEstudianteState({required this.infoEstudiante});

  @override
  void initState() {
    super.initState();
    generoEstudiante = (infoEstudiante['Genero'] == 'M') ? _genero.M : _genero.F ;
    tipoEstudiante = (infoEstudiante['Tipo'] == 'Regular') ? _tipo.Regular : _tipo.Repitiente;
    procedenciaEstudiante = (infoEstudiante['Procedencia'] == 'Hogar') ? _procedencia.Hogar :  _procedencia.Institucion;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        DateTimePicker(onChange: (fecha){
            final newDate = fecha!.toIso8601String().split('T')[0].split('-');
            widget.onCaseChange(1,fecha);
            infoEstudiante['FechaNacimiento'] = '${newDate[2]}/${newDate[1]}/${newDate[0]}';
            setState((){});
          },
          defaultText: 'Fecha de Nacimiento',
          maxDate:DateTime(DateTime.now().year - 6,12,31),
          lastDate: infoEstudiante['FechaNacimiento'],
          defaultDate:DateTime(DateTime.now().year - 6),
          enabled:widget.enabled
        ),
        Padding(padding:EdgeInsets.symmetric(vertical:5)),
        Center(child:Text('Genero',style:TextStyle(fontSize:18))),
        RadioInputRowList<_genero>(
          groupValue: generoEstudiante,
          values: [_genero.e,_genero.M,_genero.F],
          labels: ['','Masculino','Femenino'],
          ignoreFirst:true,
          onChanged: (val){
            if(!widget.enabled) return;
            widget.onCaseChange(2,val);
            setState(() {              
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
          onChanged: (val){
            if(!widget.enabled) return;
            widget.onCaseChange(3,val);
            setState(() {              
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
          onChanged: (val){
            if(!widget.enabled) return;
            widget.onCaseChange(4,val);
            setState(() {              
              procedenciaEstudiante = val!;
            });
          }
        ),
        DateTimePicker(onChange: (fecha){                                
            infoEstudiante['FechaInscripcion'] = fecha;
            widget.onCaseChange(5,fecha);
            setState((){});
          },
          defaultText: 'Fecha de Inscripción',
          maxDate:DateTime.now(),
          lastDate: (infoEstudiante['FechaInscripcion'].runtimeType == DateTime) ? '${infoEstudiante['FechaInscripcion'].toIso8601String().split('T')[0].split('-')[2]}/${infoEstudiante['FechaInscripcion'].toIso8601String().split('T')[0].split('-')[1]}/${infoEstudiante['FechaInscripcion'].toIso8601String().split('T')[0].split('-')[0]}' : (infoEstudiante['FechaInscripcion'] == null) ? '' : infoEstudiante['FechaInscripcion'] ,
          defaultDate:DateTime(DateTime.now().year,1,1),
          enabled:widget.enabled
        )
      ]
    );
  }
}

class _CamposStatefulParteRepresentante extends StatefulWidget {

  final void Function(_parentesco) onChange;
  final _parentesco parentescoDefault;
  _CamposStatefulParteRepresentante({required this.onChange,required this.parentescoDefault});

  @override
  __CamposStatefulParteRepresentanteState createState() => __CamposStatefulParteRepresentanteState(parentescoDefault:parentescoDefault);
}

class __CamposStatefulParteRepresentanteState extends State<_CamposStatefulParteRepresentante> {
  
  final _parentesco parentescoDefault;
  _parentesco parentesco = _parentesco.e;

  __CamposStatefulParteRepresentanteState({required this.parentescoDefault});

  @override
  void initState() {
    super.initState();
    switch(parentescoDefault){
      case _parentesco.Padre:
        parentesco = _parentesco.Padre;
        break;
      case _parentesco.Madre:
        parentesco = _parentesco.Madre;
        break;
      case _parentesco.Tutor:
        parentesco = _parentesco.Tutor;
        break;
      default:
      parentesco = _parentesco.e;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RadioInputRowList<_parentesco>(
      groupValue: parentesco,
      values: [_parentesco.e,_parentesco.Padre,_parentesco.Madre,_parentesco.Tutor],
      labels: ['','Padre','Madre','Tutor'],
      ignoreFirst:true,
      onChanged: (val){
        parentesco = val!;
        widget.onChange(val);
        setState((){});
      }
    );
  }
}

class _CamposStatefulParteDetalles extends StatefulWidget {

  final void Function(int changeCase, dynamic val) onCaseChange;
  final bool enabled;
  final Map<String,dynamic> infoFicha;
  //1: alergia 2: asma 3: cardiaco 4: tipaje 5: respiratorio

  _CamposStatefulParteDetalles({required this.infoFicha,required this.onCaseChange, required this.enabled});

  @override
  __CamposStatefulParteDetallesState createState() => __CamposStatefulParteDetallesState(infoFicha:infoFicha);
}

class __CamposStatefulParteDetallesState extends State<_CamposStatefulParteDetalles> {
  
  Map<String,dynamic> infoFicha;
  __CamposStatefulParteDetallesState({required this.infoFicha});
  
  @override
  Widget build(BuildContext context) {
    return Column(children:[
      Center(child:Text('Posee alergias?')),
      RadioInputRowList<bool>(groupValue: infoFicha['Alergia'], values: [true,false], labels: ['Si','No'], onChanged: (val){
        if(!widget.enabled) return;
        infoFicha['Alergia'] = val!;
        setState((){});
        widget.onCaseChange(1,val);
      }),
      Center(child:Text('Es asmatico?')),
      RadioInputRowList<bool>(groupValue: infoFicha['Asma'], values: [true,false], labels: ['Si','No'], onChanged: (val){
        if(!widget.enabled) return;
        infoFicha['Asma'] = val!;
        setState((){});
        widget.onCaseChange(2,val);
      }),
      Center(child:Text('Tiene problemas cardiacos?')),
      RadioInputRowList<bool>(groupValue: infoFicha['Cardiaco'], values: [true,false], labels: ['Si','No'], onChanged: (val){
        if(!widget.enabled) return;
        infoFicha['Cardiaco'] = val!;
        setState((){});
        widget.onCaseChange(3,val);
      }),
      Center(child:Text('Tipaje?')),
      RadioInputRowList<bool>(groupValue: infoFicha['Tipaje'], values: [true,false], labels: ['Si','No'], onChanged: (val){
        if(!widget.enabled) return;
        infoFicha['Tipaje'] = val!;
        setState((){});
        widget.onCaseChange(4,val);
      }),
      Center(child:Text('Tiene problemas respiratios?')),
      RadioInputRowList<bool>(groupValue: infoFicha['Respiratorio'], values: [true,false], labels: ['Si','No'], onChanged: (val){
        if(!widget.enabled) return;
        infoFicha['Respiratorio'] = val!;
        setState((){});
        widget.onCaseChange(5,val);
      }),
    ]);
  }
}