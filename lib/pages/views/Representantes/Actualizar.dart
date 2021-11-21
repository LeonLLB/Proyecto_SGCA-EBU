import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/controllers/Representante.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Representante.dart';

class ActualizarRepresentante extends StatefulWidget {

  @override
  State<ActualizarRepresentante> createState() => _ActualizarRepresentanteState();
}

class _ActualizarRepresentanteState extends State<ActualizarRepresentante> {

  final _formKey = GlobalKey<FormState>();

  bool modoEditar = false;

  TextEditingController controladorConsulta = TextEditingController();

  Map<String, dynamic> controladoresRepresentante = {
    'Nombres':TextEditingController(),
    'Apellidos':TextEditingController(),
    'Cedula':TextEditingController(),
    'Numero':TextEditingController(),
    'Ubicacion':TextEditingController(),
  };

  Future<Representante?> representanteF = controladorRepresentante.buscarRepresentante(null);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width * (6/10) - 200;

    return Column(
      children:[
        Form(
          key: _formKey,
          child: Center(
            child: SimplifiedContainer(            
              width: width,
              child:Row(
                children: [
                  SimplifiedTextFormField(
                    controlador: controladorConsulta,
                    labelText: 'Cedula',
                    validators: TextFormFieldValidators(required:true,isNumeric:true),  
                  ),
                VerticalDivider(),
                TextButton.icon(
                  onPressed: (){
                    representanteF = controladorRepresentante.buscarRepresentante(controladorConsulta.text == '' ? null: int.parse(controladorConsulta.text));
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
          future: representanteF,
          builder: (BuildContext context, AsyncSnapshot data) {
            if(data.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if(data.data == null){
              return Center(child:Text('No existe el representante'));
            }
            else{

              controladoresRepresentante = {
                'id':data.data.id,
                'Nombres':TextEditingController(text:data.data.nombres),
                'Apellidos':TextEditingController(text:data.data.apellidos),
                'Cedula':TextEditingController(text:data.data.cedula.toString()),
                'Numero':TextEditingController(text:data.data.numero),
                'Ubicacion':TextEditingController(text:data.data.ubicacion),
              };

              return Column(
                children:[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children:[
                      ElevatedButton.icon(onPressed: (){
                        if(modoEditar){
                          //TODA LA LOGICA DE MODIFICACIÓN
                          ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                            message:'Actualizando al representante...',
                            onVisible:()async{
                              try {
                                await controladorRepresentante.actualizar(Representante.fromForm(formInfoIntoMap(controladoresRepresentante)));
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El representante fue modificado!'));
                                modoEditar=false;
                                representanteF = controladorRepresentante.buscarRepresentante(controladorConsulta.text == '' ? null: int.parse(controladorConsulta.text));
                                setState((){});
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se ha podido actualizar al representante'));
                              }
                            }
                          ));
                        }else{
                          modoEditar=true;
                          ScaffoldMessenger.of(context).showSnackBar(simpleSnackbar('El modo de actualización fue activado, al presionar de nuevo se actualizara la información'));
                          setState((){});
                        }
                      }, icon: Icon(Icons.edit), label: Text('Actualizar representante')),
                      
                      ElevatedButton.icon(
                        style:ElevatedButton.styleFrom(primary:Colors.red),
                        onPressed: ()async {
                          final confirmacion = await confirmarEliminacion(context);
                          if(confirmacion != null && confirmacion){
                            try {
                              final result = await controladorRepresentante.eliminar(controladoresRepresentante['id']);
                              if(result != -1){
                                ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Representante eliminado con exito'));
                                representanteF = controladorRepresentante.buscarRepresentante(null);
                                controladorConsulta.text = '';
                                setState((){});                                
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Este representante tiene unos estudiantes. No se puede eliminarlo'));
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al eliminar el representante'));
                            }
                          }
                      }, icon: Icon(Icons.person_remove), label: Text('Eliminar representante'))
                    ]
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  SimplifiedContainer(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
                      children:[
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
                          ],
                          enabled:modoEditar
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
                          ],
                          enabled:modoEditar
                        ),
                        Row(
                          children: [
                            SimplifiedTextFormField(
                              controlador: controladoresRepresentante['Ubicacion'],
                              labelText: 'Dirección',
                              validators: TextFormFieldValidators(required:true),
                              icon: Icon(Icons.location_on),
                              enabled:modoEditar
                            ),
                          ],
                        )
                      ]
                    )
                  )
                ]
              );
            }
          },
        ),
      ]
    );
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
                  Text('Estas seguro de querer eliminar este representante? No se eliminara si este representa a algún estudiante. Dado el caso que se deseé eliminarlo, es recomendable cambiar de representante a sus estudiantes',
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