import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Admin.dart';
import 'package:proyecto_sgca_ebu/models/Admin.dart';

class AdminCambiarYearEscolar extends StatefulWidget {

  @override
  _AdminCambiarYearEscolarState createState() => _AdminCambiarYearEscolarState();
}

class _AdminCambiarYearEscolarState extends State<AdminCambiarYearEscolar> {

  final _formKey = GlobalKey<FormState>();
  bool existeYearEscolar = false;

  TextEditingController controlador = TextEditingController();

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
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width:150,
                  child: Row(
                    children: [
                      SimplifiedTextFormField(
                        controlador: controlador,
                        labelText: 'Año',
                        validators: TextFormFieldValidators(
                          onChange:(_){
                            setState((){});
                          },
                          required:true,
                          charLength:4,
                          isNumeric:true,
                          extraValidator: (val){
                            if(val.length != 4){
                              return 'Un año tiene 4 números minimos';
                            }
                          }
                        )
                      ),
                    ],
                  ),
                ),
                Icon(Icons.minimize),
                Text('${(controlador.text != "") ? int.parse(controlador.text) + 1 : ''}')
              ]
            ),
            Padding(padding:EdgeInsets.symmetric(vertical:5)),
            FutureBuilder(
              future: controladorAdmin.obtenerOpcion('AÑO_ESCOLAR'),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null){
                  existeYearEscolar = true;
                  return Center(child:Text('Viejo periodo: ${(snapshot.data! as Admin).valor }',
                    style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
                  ));
                }else{
                  return Center();
                }
              }
            ),
            Center(child:Text('Nuevo periodo: ${(controlador.text != "") ? (controlador.text + " - " + (int.parse(controlador.text) + 1).toString()) : ""} ',
              style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)
            )),
            Padding(padding:EdgeInsets.symmetric(vertical:5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: ()async {
                  if(_formKey.currentState!.validate()){
                    final confirmacionCambio = await confirmarCambio(context,controlador.text,1);
                    if(confirmacionCambio != null && confirmacionCambio){
                      cambiarYearEscolar(context,controlador.text,1);
                    }
                  }
                }, child: Text('Asignar año escolar',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600))),
                TextButton(onPressed: ()async {
                  if (existeYearEscolar) {
                    final confirmacionCambio = await confirmarCambio(context,controlador.text,2);
                    if(confirmacionCambio != null && confirmacionCambio){
                      cambiarYearEscolar(context,controlador.text,2);
                    }
                  }
                }, child: Text('Avanzar año escolar',style:TextStyle(fontSize: 20,fontWeight:FontWeight.w600)))
              
              ],
            )
          ]
        )
      )
    );
  }

  Future<bool?> confirmarCambio(BuildContext context, String yearEscolarInicio, int caso) async {

    if(caso == 1){
      final int yearEscolarFin = int.parse(yearEscolarInicio) + 1;
      Admin? viejoPeriodo = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');

      return showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Confirmar cambios'),
          content: SingleChildScrollView(
            child:Center(
              child:ListBody(children:[
                Center(child: Text('Esta seguro de querer cambiar el año escolar?')),
                Center(child: Text('Al hacer esta acción, toda información referente al año anterior sera eliminada!')),
                (existeYearEscolar) ? Center(child: Text('Viejo periodo: ${viejoPeriodo!.valor}')) : Center() ,
                Center(child: Text('Nuevo periodo: $yearEscolarInicio - $yearEscolarFin'))
              ])
            )
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        )
      );
    }else{
      if(await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR') == null) return false;
      
      Admin? viejoPeriodo = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');

      return showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Confirmar cambios'),
          content: SingleChildScrollView(
            child:Center(
              child:ListBody(children:[
                Center(child: Text('Esta seguro de querer avanzar el año escolar?')),
                Center(child: Text('Al hacer esta acción, toda información referente al año anterior sera eliminada!')),
                (existeYearEscolar) ? Center(child: Text('Viejo periodo: ${viejoPeriodo!.valor}')) : Center() ,
                Center(child: Text('Nuevo periodo: ${viejoPeriodo!.valor.split('-')[1]} - ${int.parse(viejoPeriodo.valor.split('-')[1]) + 1}'))
              ])
            )
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        )
      );
    }

  }

  void cambiarYearEscolar(BuildContext context, String yearEscolarInicio, int caso) async {

    if(caso == 1){
      final int yearEscolarFin = int.parse(yearEscolarInicio) + 1;
      Admin nuevaOpcion = Admin(opcion: 'AÑO_ESCOLAR',valor:'$yearEscolarInicio - $yearEscolarFin');
      
      if(existeYearEscolar){
        final opcion = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');
        nuevaOpcion.id = opcion!.id;
        
      }
      
      ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
          message:'Cambiando el año escolar...',
          onVisible: () async {
            try {
              if(existeYearEscolar){
                await controladorAdmin.actualizarOpcion('AÑO_ESCOLAR', nuevaOpcion);
              }else{
                await controladorAdmin.registrarOpcion(nuevaOpcion);
              }

              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Año escolar actualizado al periodo: ${nuevaOpcion.valor}'));
              Provider.of<PageProvider>(context,listen:false).goBack();
            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo cambiar el año escolar'));
            }
          }
        )
      );
    }else{
      Admin? viejoPeriodo = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');
      Admin nuevaOpcion = Admin(opcion: 'AÑO_ESCOLAR',valor:'${viejoPeriodo!.valor.split('-')[1]} - ${int.parse(viejoPeriodo.valor.split('-')[1]) + 1}');
      
      if(existeYearEscolar){
        final opcion = await controladorAdmin.obtenerOpcion('AÑO_ESCOLAR');
        nuevaOpcion.id = opcion!.id;        
      }

      ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
        message:'Cambiando el año escolar...',
        onVisible: () async {
          try {
            if(existeYearEscolar){
              await controladorAdmin.actualizarOpcion('AÑO_ESCOLAR', nuevaOpcion);
            }else{
              await controladorAdmin.registrarOpcion(nuevaOpcion);
            }
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Año escolar actualizado al periodo: ${nuevaOpcion.valor}'));
            Provider.of<PageProvider>(context,listen:false).goBack();
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo cambiar el año escolar'));
          }
        }
        )
      );
    }

  }
}