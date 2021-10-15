import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';


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

  representante existeRepresentante = representante.noExiste;

  final _formKey = GlobalKey<FormState>();

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

                TextButton(onPressed: (){},
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