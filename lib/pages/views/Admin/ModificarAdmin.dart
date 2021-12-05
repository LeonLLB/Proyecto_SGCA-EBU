import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/DoubleTextFormFields.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/helpers/formInfoIntoMap.dart';
import 'package:proyecto_sgca_ebu/models/Usuarios.dart';

class GestionarAdministrador extends StatefulWidget {

  @override
  _GestionarAdministradorState createState() => _GestionarAdministradorState();
}

class _GestionarAdministradorState extends State<GestionarAdministrador> {
final _formKey = GlobalKey<FormState>();

  bool modoEditar = false;

  TextEditingController controladorConsulta = TextEditingController();

  Future<Usuarios?> adminF = controladorUsuario.buscarAdmin(null);

  Map<String, dynamic> controladores = {
    'Nombres': TextEditingController(),
    'Apellidos': TextEditingController(),    
    'Cedula':TextEditingController(),
    'Contraseña':TextEditingController(),
    'Confirmar_Contraseña':TextEditingController(),
    'Correo': TextEditingController(),
    'Numero':TextEditingController(),
    'Direccion':TextEditingController(),
    'Rol':'A'
  };

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * (6/10) - 200;
    return Column(children:[
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
                  adminF = controladorUsuario.buscarAdmin(controladorConsulta.text == '' ? null: int.parse(controladorConsulta.text));
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
        future: adminF,
        builder: (BuildContext context, AsyncSnapshot data) {
          if(data.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(data.data == null){
            return Center(child:Text('No existe el administrador'));
          }
          else{
            controladores = {
              'id':data.data.id,
              'Nombres': TextEditingController(text: (data.data as Usuarios).nombres),
              'Apellidos': TextEditingController(text: (data.data as Usuarios).apellidos),    
              'Cedula':TextEditingController(text: (data.data as Usuarios).cedula.toString()),
              'Contraseña':TextEditingController(),
              'Confirmar_Contraseña':TextEditingController(),
              'Correo': TextEditingController(text: (data.data as Usuarios).correo),
              'Numero':TextEditingController(text: (data.data as Usuarios).numero),
              'Direccion':TextEditingController(text: (data.data as Usuarios).direccion),
              'Rol':'A'
            };

            return Column(
              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(onPressed: (){
                      if(modoEditar){
                        //TODA LA LOGICA DE MODIFICACIÓN
                        ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                          message:'Actualizando al docente...',
                          onVisible:()async{
                            try {
                              await controladorUsuario.actualizarAdministrador(Usuarios.fromForm(formInfoIntoMap(controladores)));
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El administrador fue modificado!'));
                              modoEditar=false;
                              adminF = controladorUsuario.buscarAdmin(controladorConsulta.text == '' ? null: int.parse(controladorConsulta.text));
                              setState((){});
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se ha podido actualizar al administrador'));
                            }
                          }
                        ));
                      }else{
                        modoEditar=true;
                        ScaffoldMessenger.of(context).showSnackBar(simpleSnackbar('El modo de actualización fue activado, al presionar de nuevo se actualizara la información'));
                        setState((){});
                      }
                    }, icon: Icon(Icons.edit), label: Text('Actualizar administrador')),
                    
                    ElevatedButton.icon(
                      style:ElevatedButton.styleFrom(primary:Colors.red),
                      onPressed: ()async {
                        final confirmacion = await confirmarEliminacion(context);
                        if(confirmacion != null && confirmacion){
                          try {
                            final result = await controladorUsuario.eliminarAdministrador(controladores['id']);
                            if(result != -1){
                              ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Administrador eliminado con exito'));
                              adminF = controladorUsuario.buscarAdmin(null);
                              controladorConsulta.text = '';
                              setState((){});                                
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Solo existe un solo administrador. No se puede eliminarlo'));
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al eliminar el administrador'));
                          }
                        }
                    }, icon: Icon(Icons.person_remove), label: Text('Eliminar administrador')),
                  ]
                ),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                SimplifiedContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    DoubleTextFormFields(
                      controladores: [
                        controladores['Nombres'],
                        controladores['Apellidos']
                      ],
                      enabled: modoEditar,          
                      iconos: [Icon(Icons.person)],
                      labelTexts: ['Nombres','Apellidos'],
                      validators: [
                        TextFormFieldValidators(required: true,isNotNumeric:true),
                        TextFormFieldValidators(required: true,isNotNumeric:true)
                      ]
                    ),
                    DoubleTextFormFields(
                      controladores: [
                        controladores['Cedula'],
                        controladores['Numero']
                      ],
                      enabled: modoEditar,  
                      iconos: [
                        Icon(Icons.person),
                        Icon(Icons.phone)
                      ],
                      labelTexts: ['Cedula','Número'],
                      validators: [
                        TextFormFieldValidators(
                          required:true,
                          isNumeric: true,
                          charLength:9
                        ),
                        TextFormFieldValidators(isNumeric: true,charLength:11),
                      ]
                    ),
                    DoubleTextFormFields(
                      controladores: [
                        controladores['Correo'],
                        controladores['Direccion']
                      ],
                      enabled: modoEditar,  
                      iconos: [
                        Icon(Icons.mail),
                        Icon(Icons.location_on)
                      ],
                      labelTexts: [
                        'Correo electronico',
                        'Direccion'
                      ],
                      validators: [
                        TextFormFieldValidators(isEmail: true),
                        TextFormFieldValidators()
                      ]
                    ),
                    DoubleTextFormFields(
                      controladores: [
                        controladores['Contraseña'],
                        controladores['Confirmar_Contraseña']
                      ],
                      enabled: modoEditar,  
                      iconos: [
                        Icon(Icons.lock),
                        Icon(Icons.lock)
                      ],
                      labelTexts: ['Contraseña','Confirmar contraseña'],
                      obscureTexts: [true,true],
                      validators: [
                        TextFormFieldValidators(required:true),
                        TextFormFieldValidators(required:true,extraValidator:(val){
                          if(val != controladores['Contraseña'].text) return 'Las contraseñas no coinciden';
                        })
                      ]
                    ),
                  ])
                )
              ]
            ); 
          }
        },
      ),
    ]);
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
                  Text('Estas seguro de querer eliminar este administrador? No se eliminara si es el unico administrador inscrito en el sistema',
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