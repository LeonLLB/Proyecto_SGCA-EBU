import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Estudiante.dart';
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
 
  TextEditingController inscripcionYear = TextEditingController(text:DateTime.now().year.toString());

  representante existeRepresentante = representante.noExiste;
  int gradoACursar = 0;

  final _formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();

  Map<String, dynamic> controladoresEstudiante = {
    'Nombres':TextEditingController(),
    'Apellidos':TextEditingController(),
    'LugarNacimiento':TextEditingController(),
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
      'FechaNacimiento':'',
      'Genero':'',
      'Tipo':'',
      'Procedencia':'',
    };

    generoEstudiante = genero.e;
    tipoEstudiante = tipo.e;
    procedenciaEstudiante = procedencia.e;

    inscripcionYear = TextEditingController(text:DateTime.now().year.toString());

    existeRepresentante = representante.noExiste;
    setState((){});
  }

  Future<DateTime?> getDate (BuildContext context,String? date)=>showDatePicker(
    context: context,
    initialDate: (date != null && date != '') ? 
    DateTime(int.parse(date.split('/')[2]),int.parse(date.split('/')[1]),int.parse(date.split('/')[0])) :
    DateTime(DateTime.now().year - 6),
    firstDate: DateTime(2000),
    lastDate: DateTime(DateTime.now().year - 6,12,31)
    );

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
                  Row(
                    children: [
                      SimplifiedTextFormField(
                        controlador: controladoresEstudiante['LugarNacimiento'],
                        labelText: 'Lugar de nacimiento',
                        validators: TextFormFieldValidators(required:true),
                        icon: Icon(Icons.location_on),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: ()async{
                            final date = await getDate(context,controladoresEstudiante['FechaNacimiento']);
                            if(date != null){
                              final fecha = date.toIso8601String().split('T')[0].split('-');
                              controladoresEstudiante['FechaNacimiento'] = '${fecha[2]}/${fecha[1]}/${fecha[0]}';
                              setState(() {});
                            }
                          },
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.calendar_today),
                              Text(
                                (controladoresEstudiante['FechaNacimiento'] == '')?
                                'Fecha de nacimiento':
                                '${controladoresEstudiante['FechaNacimiento']}',
                                style:TextStyle(fontSize:16)),
                            ],
                          )
                        )
                      )
                  ]),
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
                        if(val == procedencia.Hogar){
                          gradoACursar = 1;
                        }
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
    
                _ContenedorForm([Row(children:[SimplifiedTextFormField(
                  controlador: inscripcionYear,
                  labelText: 'Año de inscripción',
                  validators: TextFormFieldValidators(required:true,isNumeric:true)
                )])]),
                
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
                      inscripcionYear: int.parse(inscripcionYear.text)
                    );
                    if(controladoresEstudiante['Procedencia'] != 'Hogar'){
                      gradoACursar = await getGradoACursar(context);
                    }
                    if(gradoACursar > 0){
    
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

  Future<int> getGradoACursar (BuildContext context)async{
    List<String> grados = ['1er','2do','3er','4to','5to','6to'];
    switch(await showDialog<String>(context: context, builder: (_)=>SimpleDialog(
      title: Text('Grado a cursar'),
      children: grados.map((grado) => SimpleDialogOption(
        onPressed: (){Navigator.pop(_,grado);},
        child: Text('$grado grado')
      )).toList()
    ))){
      case '1er':
        return 1;
      case '2do':
        return 2;
      case '3er':
        return 3;
      case '4to':
        return 4;
      case '5to':
        return 5;
      case '6to':
        return 6;
      case null:
        return gradoACursar;
      default:
        return 0;
    }
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
          Text('$gradoACursar grado')
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
              final result = await controladorEstudiante.registrar(estudianteAInscribir,cedulaRepresentante: int.parse(infoRepresentante['Cedula'].text),gradoDeseado:gradoACursar);
              
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
              final result = await controladorEstudiante.registrar(estudianteAInscribir,representante:represententanteAInscribir,gradoDeseado:gradoACursar);
              
              
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