import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';
import 'package:proyecto_sgca_ebu/routes.dart';

class CustomSideBarItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final String route;

  CustomSideBarItem({
    required this.icon,
    required this.label,
    required this.route,
  }){
    assert(routes[this.route] != null , 'No existe la ruta ${this.route}');
    assert(!this.route.startsWith('/') || !(this.route != '/home'), 'La ruta solicitada es de caracter de navegacion, mas no interno');
  }

  @override
  Widget build(BuildContext context) {

    final page = Provider.of<PageProvider>(context).page;

    return ListTile(
      leading:Icon(icon,color:(page.startsWith(route)) ? Color(0xff96baff) : Colors.black ),
      title:Text(label, style: TextStyle(color: (page.startsWith(route)) ? Color(0xff96baff) : Colors.black)),
      onTap:(){
        if (route != page) {          
          
          final conditionOfSubstraction = Provider.of<PageProvider>(context,listen:false).history.length > 1;
          final finalConditionOfSubstraction = Provider.of<PageProvider>(context,listen:false).history.length > 2;
          Provider.of<PageProvider>(context,listen:false).page = route;
          
          if(!route.startsWith('/')){
            if (finalConditionOfSubstraction) {
              Provider.of<PageProvider>(context,listen:false).substractFromHistory();
              Provider.of<PageProvider>(context,listen:false).substractFromHistory();
              Provider.of<PageProvider>(context,listen:false).addToHistory(label,route);
            }else if(conditionOfSubstraction){
              Provider.of<PageProvider>(context,listen:false).substractFromHistory();
              Provider.of<PageProvider>(context,listen:false).addToHistory(label,route);
            }else{
              Provider.of<PageProvider>(context,listen:false).addToHistory(label,route);
            }
          }

          else if(route == '/home'){          
            if (conditionOfSubstraction) {
              Provider.of<PageProvider>(context,listen:false).history = [{'route':'/home','name':'home'}];
            }
          }

        }
      }
    );
  }
}