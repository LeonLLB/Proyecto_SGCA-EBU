import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DateTimePicker.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';



class InscribirEstudiante extends StatefulWidget {

  @override
  _InscribirEstudianteState createState() => _InscribirEstudianteState();
}

enum genero {e,M,F}
enum tipo {e,Regular,Repitiente}
enum procedencia {e,Hogar,Institucion}
enum representante {existe,noExiste}

class _InscribirEstudianteState extends State<InscribirEstudiante> {

  genero generoEstudiante = genero.e;
  tipo tipoEstudiante = tipo.e;
  procedencia procedenciaEstudiante = procedencia.e;
  DateTime fechaInscripcion = DateTime.now();

  representante existeRepresentante = representante.noExiste;
  Ambiente? gradoACursar;

  final _formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();

  Map<String, dynamic> controladoresEstudiante = {
    'Nombres':TextEditingController(),
    'Apellidos':TextEditingController(),
    'LugarNacimiento':TextEditingController(),
    'EstadoNacimiento':TextEditingController(),
    'FechaNacimiento':'',
    'Genero':'',
    'Tipo':'',
    'Procedencia':'',
  };

  Map<String, dynamic> controladoresRepresentante = {
      'Nombres':TextEditingController(),
      'Apellidos':TextEditingController(),
      'Cedula':TextEditingController(),
      'Numero':TextEditingController(),
      'Ubicacion':TextEditingController(),
    };

  void resetForm(){
    controladoresRepresentante = {
      'Nombres':TextEditingController(),
      'Apellidos':TextEditingController(),
      'Cedula':TextEditingController(),
      'Numero':TextEditingController(),
      'Ubicacion':TextEditingController(),
    };
    controladoresEstudiante = {
      'Nombres':TextEditingController(),
      'Apellidos':TextEditingController(),
      'LugarNacimiento':TextEditingController(),
      'EstadoNacimiento':TextEditingController(),
      'FechaNacimiento':'',
      'Genero':'',
      'Tipo':'',
      'Procedencia':'',
    };

    generoEstudiante = genero.e;
    tipoEstudiante = tipo.e;
    procedenciaEstudiante = procedencia.e;

    existeRepresentante = representante.noExiste;
    setState((){});
  }  

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                // ESTUDIANTE
                _ContenedorForm([
                  Center(child:Text('Información del estudiante:',
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
                    ]
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
                    ]
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  DateTimePicker(onChange: (fecha){
                      final newDate = fecha!.toIso8601String().split('T')[0].split('-');
                      controladoresEstudiante['FechaNacimiento'] = '${newDate[2]}/${newDate[1]}/${newDate[0]}';
                      setState((){});
                    },
                    defaultText: 'Fecha de Nacimiento',
                    maxDate:DateTime(DateTime.now().year - 6,12,31),
                    defaultDate:DateTime(DateTime.now().year - 6),
                    lastDate:controladoresEstudiante['FechaNacimiento'],
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  Center(child:Text('Genero',style:TextStyle(fontSize:18))),
                  RadioInputRowList<genero>(
                    groupValue: generoEstudiante,
                    values: [genero.e,genero.M,genero.F],
                    labels: ['','Masculino','Femenino'],
                    ignoreFirst:true,
                    onChanged: (val){
                      setState(() {
                        controladoresEstudiante['Genero'] = val.toString().split('.')[1];
                        generoEstudiante = val!;
                      });
                    }
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  Center(child:Text('Tipo de estudiante',style:TextStyle(fontSize:18))),
                  RadioInputRowList<tipo>(
                    groupValue: tipoEstudiante,
                    values: [tipo.e,tipo.Regular,tipo.Repitiente],
                    labels: ['','Regular','Repitiente'],
                    ignoreFirst:true,
                    onChanged: (val){
                      setState(() {
                        controladoresEstudiante['Tipo'] = val.toString().split('.')[1];
                        tipoEstudiante = val!;
                      });
                    }
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  Center(child:Text('Viene del:',style:TextStyle(fontSize:18))),
                  RadioInputRowList<procedencia>(
                    groupValue: procedenciaEstudiante,
                    values: [procedencia.e,procedencia.Hogar,procedencia.Institucion],
                    labels: ['','Hogar','Institución'],
                    ignoreFirst:true,
                    onChanged: (val){
                      setState(() {
                        controladoresEstudiante['Procedencia'] = val.toString().split('.')[1];
                        procedenciaEstudiante = val!;
                        
                      });
                    }
                  ),
                ]),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                // REPRESENTANTE
    
                Center(child:Text('Su representante ya esta inscrito?',style:TextStyle(fontSize:18))),
                  RadioInputRowList<representante>(
                    groupValue: existeRepresentante,
                    values: [representante.existe,representante.noExiste],
                    labels: ['Si','No'],
                    onChanged: (val){
                      setState(() {                        
                        existeRepresentante = val!;
                      });
                    }
                  ),
                  
    
                (existeRepresentante == representante.noExiste) ? _ContenedorForm([
                  Center(child:Text('Representante del estudiante:',
                    style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))
                  ),
                  DoubleTextFormFields(
                    controladores: [
                      controladoresRepresentante['Nombres'],
                      controladoresRepresentante['Apellidos']
                    ],
                    iconos: [Icon(Icons.person)],
                    labelTexts: ['Nombres','Apellidos'],
                    validators: [
                      TextFormFieldValidators(required:true,isNotNumeric:true),                   
                      TextFormFieldValidators(required:true,isNotNumeric:true)
                    ]
                  ),
                  DoubleTextFormFields(
                    controladores: [
                      controladoresRepresentante['Cedula'],
                      controladoresRepresentante['Numero']
                    ],
                    iconos: [
                      Icon(Icons.assignment_ind),
                      Icon(Icons.phone)
                    ],
                    labelTexts: ['Cedula','Telefono'],
                    validators: [
                      TextFormFieldValidators(required:true,isNumeric:true,charLength:9),                  
                      TextFormFieldValidators(required:true,isNumeric:true,charLength:11)
                    ]
                  ),
                  Row(
                    children: [
                      SimplifiedTextFormField(
                        controlador: controladoresRepresentante['Ubicacion'],
                        labelText: 'Dirección',
                        validators: TextFormFieldValidators(required:true),
                        icon: Icon(Icons.location_on)
                      ),
                    ],
                  )
                ]) 
                : _ContenedorForm([Row(children:[SimplifiedTextFormField(
                    controlador: controladoresRepresentante['Cedula'],
                    labelText: 'Cedula del representante',
                    validators: TextFormFieldValidators(required:true,isNumeric:true,charLength:9),
                    icon: Icon(Icons.assignment_ind)
                  )])]),
    
                Padding(padding:EdgeInsets.symmetric(vertical:5)),   
          
                DateTimePicker(onChange: (fecha){
                    fechaInscripcion = fecha!;
                    setState((){});
                  },
                  defaultText: 'Fecha de inscripcion',
                  maxDate:DateTime.now(),
                  lastDate:'${fechaInscripcion.toIso8601String().split('T')[0].split('-')[2]}/${fechaInscripcion.toIso8601String().split('T')[0].split('-')[1]}/${fechaInscripcion.toIso8601String().split('T')[0].split('-')[0]}',
                  defaultDate:DateTime(DateTime.now().year,1,1)
                ),
                
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
    
                TextButton(onPressed: ()async{
                  if(
                    _formKey.currentState!.validate() &&
                    controladoresEstudiante['FechaNacimiento'] != '' &&
                    controladoresEstudiante['Genero'] != '' &&
                    controladoresEstudiante['Tipo'] != '' &&
                    controladoresEstudiante['Procedencia'] != ''
                  ){
                    controladoresEstudiante['Cedula'] = await controladorEstudiante.calcularCedulaEscolar(
                      cedulaRepresentante: int.parse(controladoresRepresentante['Cedula'].text),
                      nacimientoYear: int.parse(controladoresEstudiante['FechaNacimiento'].split('/')[2])
                    );
                    if(controladoresEstudiante['Procedencia'] != 'Hogar'){
                      gradoACursar = await getGradoACursar(context,true);
                    }else{
                      gradoACursar = await getGradoACursar(context,false);
                    }
                    if(gradoACursar != null){
    
                      final inscripcionConfirmada = await confirmarInscripcion(
                        controladoresEstudiante,
                        controladoresRepresentante,
                        context,(existeRepresentante == representante.existe)
                      );
    
                      if(inscripcionConfirmada != null && inscripcionConfirmada){
                        crearEstudiante(
                          controladoresEstudiante,
                          controladoresRepresentante,
                          context,(existeRepresentante == representante.existe));
                      }
                      
                    }
                    
                  }else{
                    ScaffoldMessenger.of(context)
                    .showSnackBar(failedSnackbar('Todos los campos son obligatorios'));
                  }
                },
                child: Text('Inscribir estudiante y representante',
                style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600))),
    
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
              ],
            )
          ),
        ),
      ),
    );
  }

  Future<Ambiente?> getGradoACursar (BuildContext context,bool todosLosAmbientes)async{

    final List<Map<String,Object?>>? grados = await controladorAmbientes.obtenerAmbientesConEstudiantes((todosLosAmbientes) ? null : 1);

    if(grados == null) return null;

    return await showDialog<Ambiente>(context: context, builder: (_)=>SimpleDialog(
      title: Text('Grado a cursar'),
      children: grados.map((grado) => SimpleDialogOption(
        onPressed: (){Navigator.pop(_,Ambiente.fromMap(grado));},
        child: Text('${grado['grado']}° grado \"${grado['seccion']}\" Turno: ${(grado['turno'] == 'M') ? 'Mañana':'Tarde'} Estudiantes: ${grado['cantidadEstudiantes']}')
      )).toList()
    ));
  }

  Future<bool?> confirmarInscripcion(
    Map<String, dynamic> infoEstudiante,
    Map<String, dynamic> infoRepresentante,
    BuildContext context,
    bool representanteInscrito
  )async{

    final List<Widget> parteDelEstudiante = [
      Center(child: Text('Estudiante',style:TextStyle(fontWeight: FontWeight.bold))),
      Center(child: Text('${infoEstudiante["Nombres"].text} ${infoEstudiante["Apellidos"].text}',style:TextStyle(fontWeight: FontWeight.bold))),
      Center(
        child: Row(children: [
          Text('C.I Escolar: ',style:TextStyle(fontWeight: FontWeight.bold)),
          Text(infoEstudiante['Cedula'].toString())
        ]),
      ),
      Center(
        child: Row(children: [
          Text('Edad: ',style:TextStyle(fontWeight: FontWeight.bold)),
          Text('${calcularEdad(infoEstudiante["FechaNacimiento"])} años')
        ]),
      ),
      Center(
        child: Row(children: [
          Text('Grado a ${(infoEstudiante["Tipo"] == "Repitiente") ? "repetir" : "cursar" }: ',style:TextStyle(fontWeight: FontWeight.bold)),
          Text('${gradoACursar!.grado}° \"${gradoACursar!.seccion}\"')
        ]),
      ),
    ];

    if(representanteInscrito){
      final Representante? representante = await controladorRepresentante.buscarRepresentante(int.parse(infoRepresentante['Cedula'].text));
      if(representante == null){
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No existe el representante solicitado'));
        return false;
      }
      else{
        return showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirmar inscripción'),
            content: SingleChildScrollView(
              child: Center(
                child: ListBody(
                  children: [
                    ...parteDelEstudiante,
                    Center(child: Text('Representante',style:TextStyle(fontWeight: FontWeight.bold))),
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
    }else{
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirmar inscripción'),
          content: SingleChildScrollView(
            child: Center(
              child: ListBody(
                children: [
                  ...parteDelEstudiante,
                  Text('Representante',style:TextStyle(fontWeight: FontWeight.bold)),
                  Text('${infoRepresentante["Nombres"].text} ${infoRepresentante["Apellidos"].text}',style:TextStyle(fontWeight: FontWeight.bold)),
                  Row(children: [
                    Text('C.I:',style:TextStyle(fontWeight: FontWeight.bold)),
                    Text(infoRepresentante["Cedula"].text)
                  ]),
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

  void crearEstudiante(    
    Map<String, dynamic> infoEstudiante,
    Map<String, dynamic> infoRepresentante,
    BuildContext context,
    bool representanteInscrito) async {
      
      final Estudiante estudianteAInscribir = Estudiante.fromForm(formInfoIntoMap(infoEstudiante));
      
      if(representanteInscrito){

        ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
          message:'Registrando estudiante...',
          onVisible: () async {
            try {
              final result = await controladorEstudiante.registrar(estudianteAInscribir,cedulaRepresentante: int.parse(infoRepresentante['Cedula'].text),ambienteSeleccionado:gradoACursar!,procedencia:infoEstudiante['Procedencia'],tipo:infoEstudiante['Tipo'],fechaInscripcion:fechaInscripcion);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              
              if(result == 0){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo crear el estudiante'));
              }
              
              else if(result == -1){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No existe el representante solicitado'));
              }

              else if(result == -2){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo asignar al estudiante a un grado'));
              }

              else if(result == -3){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No existe el grado solicitado: $gradoACursar'));
              }  

              else{
                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Estudiante creado con exito!'));
                resetForm();
              }
            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al crear el estudiante'));
            }
          }
        ));
      
      }else{
        if(await controladorRepresentante.buscarRepresentante(int.parse(infoRepresentante['Cedula'].text)) == null){
          final Representante represententanteAInscribir = Representante.fromForm(formInfoIntoMap(infoRepresentante));
                 
          ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
          message:'Registrando estudiante y representante...',
          onVisible: () async {
            try {
              final result = await controladorEstudiante.registrar(estudianteAInscribir,representante:represententanteAInscribir,ambienteSeleccionado:gradoACursar!,procedencia:infoEstudiante['Procedencia'],tipo:infoEstudiante['Tipo'],fechaInscripcion:fechaInscripcion);
              
              
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              
              if(result == -1){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('El representante ya existe'));
              }

              else if(result == -2){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo asignar al estudiante a un grado'));
              }

              else if(result == -3){
                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No existe el grado solicitado: $gradoACursar'));
              }

              else{
                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Estudiante y representante creados con exito!'));
                resetForm();
              }            

            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al crear el estudiante o representante'));
            }
          }
          ));
        }else{
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Ya existe un representante para esa cedula'));
        }
      }

    }    
  
}

class _ContenedorForm extends StatelessWidget {

  final List<Widget> children;

  _ContenedorForm(this.children);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * (9/10) - 200,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff7C83FD), width: 4),
        borderRadius: BorderRadius.circular(20)
      ),      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
        children:children
      )
    );
  }
}