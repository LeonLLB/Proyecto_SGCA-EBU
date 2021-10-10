import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';

void changePage (BuildContext context,String route, String label){

  final page = Provider.of<PageProvider>(context,listen:false).page;

  if (route != page) {          
          
    final conditionOfSubstraction = Provider.of<PageProvider>(context,listen:false).history.length > 1;
    Provider.of<PageProvider>(context,listen:false).page = route;
    
    if(!route.startsWith('/')){
      if (conditionOfSubstraction) {
        Provider.of<PageProvider>(context,listen:false).substractFromHistory();
        Provider.of<PageProvider>(context,listen:false).addToHistory(label,route);
      }else{
        Provider.of<PageProvider>(context,listen:false).addToHistory(label,route);
      }
    }
    else if(route == '/home'){          
      if (conditionOfSubstraction) {
        Provider.of<PageProvider>(context,listen:false).substractFromHistory();
      }
    }

  }
}

List<Widget> _historyToWidgets (List<Map<String,String>> history,BuildContext context){
  List<Widget> widgets = [];

  for(var page in history){
    if(history[history.length-1]['name'] != page['name']){
      widgets.addAll([
        TextButton(
          onPressed: (){
            changePage(context,page['route']!,page['name']!);
          },
          child: (page['name'] == 'home') ?
          Icon(Icons.home,size:12,color:Colors.black) :
          Text(page['name']!,style:TextStyle(fontSize:12,color:Colors.black))
          ),
        Icon(Icons.chevron_left,size:12)
      ]);
    }else{
      widgets.add(TextButton(
        onPressed: (){
          changePage(context,page['route']!,page['name']!);
        },
        child: (page['name'] == 'home') ?
        Icon(Icons.home,size:12,color:Colors.black) :
        Text(page['name']!,style:TextStyle(fontSize:12,color:Colors.black))
      ));
    }
  }

  return widgets;

}

class PageBreadCumbs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Map<String,String>> history = Provider.of<PageProvider>(context).history;

    return Row(children: _historyToWidgets(history,context));
  }
}