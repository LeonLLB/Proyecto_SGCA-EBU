import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DateTimePicker.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/MesPicker.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/snackbars.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/FichaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaEstudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Record.dart';
import 'package:proyecto_sgca_ebu/controllers/RecordFicha.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Ficha_Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';
import 'package:proyecto_sgca_ebu/models/Matricula_Estudiante.dart';
import 'package:proyecto_sgca_ebu/services/PDF.dart';

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

  int mes = DateTime.now().month;

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
                    Wrap(
                      spacing:5,
                      runSpacing:5,
                      alignment:WrapAlignment.spaceEvenly,
                      children:[
                        ElevatedButton.icon(
                          onPressed: (){
                            if(!modoEditar){
                              modoEditar=true;
                              ScaffoldMessenger.of(context).showSnackBar(simpleSnackbar('El modo de actualizaci??n fue activado, al presionar de nuevo se actualizara la informaci??n'));
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
                        ),
                        ElevatedButton(onPressed:(){
                          ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                            message:'Generando documento de ficha...',
                            onVisible: () async {
                              final bool seGenero = await generarDocumentoFicha(int.parse(controladoresEstudiante['Cedula'].text));
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              if(seGenero){
                                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente el documento, revise el directorio de descargas'));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar el documento'));
                              }
                            }
                            )
                          );
                        },child:Text('Generar PDF de Ficha')),
                        ElevatedButton(onPressed:(){
                          ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                            message:'Generando boletin...',
                            onVisible: () async {
                              final bool seGenero = await generarBoletin(controladoresEstudiante['id']);
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              if(seGenero){
                                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente el boletin, revise el directorio de descargas'));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar el boletin'));
                              }
                            }
                            )
                          );
                        },child:Text('Generar PDF de Boletin')),
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
                              child:Text('Informaci??n del estudiante:',
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
                              child:Text('Informaci??n del representante:',
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
                          Text(data.data['a??oEscolar'] == null ? 'No esta inscrito al a??o actual!' : 'A??o escolar: ${data.data['a??oEscolar']}'),                  
                          Text(data.data['a??oEscolar'] == null ? '' : 'Aula: ${data.data['grado']}?? \"${data.data['seccion']}\"'),   
                          Text(data.data['a??oEscolar'] == null ? '' : 'Turno: ${(data.data['turno'] == 'M') ? 'Ma??ana' : 'Tarde' }'),   
                          Text((data.data['a??oEscolar'] != null && data.data['d.nombres'] != null) ? 'Docente: ${data.data['d.nombres']} ${data.data['d.apellidos']}' : ''),   
                          Text((data.data['a??oEscolar'] != null && data.data['d.nombres'] != null) ? 'C.I: ${data.data['d.cedula']}' : ''),   
                          Padding(padding:EdgeInsets.symmetric(vertical:5)),
                          MesPicker(
                            defMes: mes,
                            defLabel:'Mes seleccionado:',
                            onChange: (mesSeleccionado){
                              mes = mesSeleccionado!;
                              
                              setState((){});
                            }
                          ),
                          Padding(padding:EdgeInsets.symmetric(vertical:5)),
                          ElevatedButton(onPressed: ()async{
                            final resultCaso = await controladorMatriculaEstudiante.casoDeCambioDeMatricula(controladoresEstudiante['id']);
                            
                            final gradoSeleccionado = await seleccionarAmbienteAlCambiar(resultCaso['listado'], context);
                            if(gradoSeleccionado != null){
                              cambiarMatricula(context,data.data['me.id'],controladoresEstudiante['Genero'],resultCaso['caso'],controladoresEstudiante['id'],gradoSeleccionado,data.data['a??oEscolar']);
                            }
                          }, child: Text('Cambiar o asignar matricula'))
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
                    ),
                    (casoTablaVisualizar != _casoTabla.invisible) ? _Tablas(caso:casoTablaVisualizar,estudianteID:controladoresEstudiante['id']) : SizedBox()
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

  Future<Ambiente?> seleccionarAmbienteAlCambiar(
    List<Ambiente> ambientesDisponibles,
    BuildContext context
  ) async{
    final estudiantesPorGrado = await controladorMatriculaEstudiante.contarEstudiantes(ambientesDisponibles);
    return showDialog<Ambiente>(
      context:context,
      builder:(BuildContext context) => SimpleDialog(
        title: Text('Grado a cursar'),
        children: ambientesDisponibles.map((ambiente) => SimpleDialogOption(
          onPressed: (){Navigator.pop(context,ambiente);},
          child: Text('${ambiente.grado}?? grado \"${ambiente.seccion}\" Estudiante: ${estudiantesPorGrado['${ambiente.grado}${ambiente.seccion}']}')
        )).toList()
      )
    );
  }
  
  Future<bool?> confirmarEliminacion(
    BuildContext context
  )async{
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar eliminaci??n'),
        content: SingleChildScrollView(
          child: Center(
            child: ListBody(
              children: [
                Icon(Icons.warning,color:Colors.red,size:72),                  
                Wrap(
                  children:[
                  Text('Estas seguro de querer eliminar este estudiante? Toda informaci??n que tenga que ver con el mismo sera eliminada de manera permanente, se recomienda respaldar su bolet??n u otros datos primero',
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

  void cambiarMatricula(BuildContext context,int matriculaID,String genero,int caso, int estudianteID, Ambiente ambienteSeleccionado, String yearEscolar) {
    if(caso == 1){
      ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
        message:'Cambiando matr??cula...',
        onVisible:()async{
          try {
            await controladorMatriculaEstudiante.cambiarMatricula(MatriculaEstudiante(
              id:matriculaID,
              ambienteID: ambienteSeleccionado.id!,
              estudianteID: estudianteID,
              yearEscolar: yearEscolar
            ),mes,genero);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha cambiado el grado del estudiante!'));
            fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(int.parse(controladorConsulta.text));
            setState((){});
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al cambiar el grado del estudiante'));
          }
        }
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
        message:'Subiendo matr??cula...',
        onVisible:()async{
          try {
            await controladorMatriculaEstudiante.registrar(estudianteID, ambienteSeleccionado);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El estudiante esta inscrito a ${ambienteSeleccionado.grado}?? ${ambienteSeleccionado.seccion}'));
            fichaEstudiante = controladorFichaEstudiante.getFichaCompleta(int.parse(controladorConsulta.text));
            setState((){});
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al inscribir al estudiante al grado ${ambienteSeleccionado.grado}?? ${ambienteSeleccionado.seccion}'));
          }
        }
      ));
    }
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
          labels: ['','Hogar','Instituci??n'],
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
          defaultText: 'Fecha de Inscripci??n',
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

class _Tablas extends StatelessWidget {
  
  final _casoTabla caso;
  final int estudianteID;

  _Tablas({required this.caso, required this.estudianteID});

  @override
  Widget build(BuildContext context) {
    return (caso == _casoTabla.recordFicha) ? _TablaRecordFicha(estudianteID:estudianteID) : _TablaRecordBoletin(estudianteID:estudianteID);
  }
}

class _TablaRecordFicha extends StatelessWidget {

  final int estudianteID;

  _TablaRecordFicha({required this.estudianteID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controladorRecordFicha.obtenerRecords(estudianteID),
      builder: (BuildContext context, AsyncSnapshot data) {
        if(data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(data.data == null){
          return Center(child:Text('No hubo resultados, esto puede deberse a que no haya ning??n record para el estudiante'));
        }else{
          return Table(
            border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
            children: [
              TableRow(
                children:[
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('Talla')),
                    )
                  ),
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('Peso')),
                    )
                  ),
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('Edad')),
                    )
                  ),
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('A??o escolar')),
                    )
                  )
                ]
              ),
              ...data.data.map((record)=>TableRow(children:[
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(record.talla.toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(record.peso.toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(record.edad.toString())),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(record.yearEscolar)),
                  )
                )
              ])).toList()
            ],
          );
        }
      },
    );
  }
}

class _TablaRecordBoletin extends StatelessWidget {

  final int estudianteID;

  _TablaRecordBoletin({required this.estudianteID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controladorRecord.obtenerRecordsDeEstudiante(estudianteID),
      builder: (BuildContext context, AsyncSnapshot data) {
        if(data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(data.data == null){
          return Center(child:Text('No hubo resultados, esto puede deberse a que no haya ning??n record para el estudiante, o que el estudiante todavia no haya progresado a otro a??o escolar'));
        }else{
          return Table(
            border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
            children: [
              TableRow(
                children:[
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('Rendimiento')),
                    )
                  ),
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('Grado y secci??n')),
                    )
                  ),
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('A??o escolar')),
                    )
                  ),
                  TableCell(
                    child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(child: Text('Fecha inscripcion')),
                    )
                  )
                ]
              ),
              ...data.data.map((record)=>TableRow(children:[
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text((record.aprobado)?'Aprobado':'Reprobado')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text('${record.gradoCursado}?? \"${record.seccionCursada}\"')),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(record.yearEscolar)),
                  )
                ),
                TableCell(
                  child:  Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(record.fechaInscripcion)),
                  )
                )
              ])).toList()
            ],
          );
        }
      },
    );
  }
}