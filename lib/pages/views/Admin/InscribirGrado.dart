import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';

enum turno {e,M,T}

class AdminInscribirGrado extends StatefulWidget {

  @override
  _AdminInscribirGradoState createState() => _AdminInscribirGradoState();
}

class _AdminInscribirGradoState extends State<AdminInscribirGrado> {
  final _formKey = GlobalKey<FormState>();

  turno turnoAmbiente = turno.e;

  Map<String,dynamic> controladores ={
    'Grado':TextEditingController(),
    'Sección':TextEditingController(),
    'Turno':''
  };

  void resetForm(){
    controladores ={
      'Grado':TextEditingController(),
      'Sección':TextEditingController(),
      'Turno':''
    };
    turnoAmbiente = turno.e;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * (9/10) - 200,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff7C83FD), width: 4),
          borderRadius: BorderRadius.circular(20)
        ),      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
          children:[
            DoubleTextFormFields(
              controladores: [
                controladores['Grado'],
                controladores['Sección']
              ],
              iconos: [Icon(Icons.assignment)],
              labelTexts: ['Grado','Sección'],              
              validators: [
                TextFormFieldValidators(required:true,charLength:1,isNumeric:true),
                TextFormFieldValidators(required:true,charLength:1,isNotNumeric:true),
              ]
            ),
            Center(child:Text('Turno de la sección:',
              style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
            )),
            RadioInputRowList<turno>(
              groupValue: turnoAmbiente,
              values: [turno.e,turno.M,turno.T],
              labels: ['e','Mañana','Tarde'],
              ignoreFirst:true,
              onChanged: (val){
                setState((){
                  controladores['Turno']=val!.toString().split('.')[1];
                  turnoAmbiente=val;
                });
              }
            ),
            Padding(padding:EdgeInsets.symmetric(vertical:5)),
            TextButton(onPressed: (){
              if(_formKey.currentState!.validate() && controladores['Turno'] != ''){
                crearGrado(context,controladores);
              }
            }, child: Text('Inscribir grado',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600)))

          ]
        )
      ),
    );
  }

  void crearGrado(BuildContext context, Map<String,dynamic> info)  {
    final Ambiente ambienteNuevo = Ambiente.fromForm(formInfoIntoMap(info));

    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Registrando grado...',
      onVisible: () async{
        try {
          if(ambienteNuevo.grado > 6 || ambienteNuevo.grado < 1){
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('El grado ${ambienteNuevo.grado} no es valido (1-6) '));
          }else{
            await controladorAmbientes.registrarAmbiente(ambienteNuevo);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Grado creado con exito!'));
            resetForm();
          }
        } catch (e) {
          
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          if(e.toString().contains('UNIQUE constraint failed')){
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('El ambiente ${ambienteNuevo.grado} \"${ambienteNuevo.seccion}\" ya existe '));
          }else{      
            print(e);      
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al crear el grado, tal vez ya exista'));
          }
          
        }
      }
    ));
  }
}