import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/RadioInput.dart';

class RadioInputRowList<T> extends StatelessWidget {

  final T groupValue;
  final List<T> values;
  final List<String> labels;
  final void Function(T? val) onChanged;
  final bool? ignoreFirst;

  RadioInputRowList({
    required this.groupValue,
    required this.values,
    required this.labels,
    required this.onChanged,
    this.ignoreFirst : false
  }){
    assert(values.length == labels.length, "Por cada valor debe haber un descriptor, valores = ${values.length} , descriptores = ${labels.length}");
  }

  List<Widget> mapListWidget(){
    int i = 0;
    List<Widget> list =[];

    for(var value in values.asMap().entries){
      if(i == 0 && ignoreFirst!){
        i+= 1;
      }
      else{        
        list.add(RadioInput<T>(
        groupValue: groupValue,
        value: value.value,
        label: labels[value.key],
        onChanged: onChanged
        ));
      }        
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: mapListWidget()
    );
  }
}