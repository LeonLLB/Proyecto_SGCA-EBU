import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/RadioInput.dart';

class RadioInputRowList<T> extends StatelessWidget {

  final T groupValue;
  final List<T> values;
  final List<String> labels;
  final void Function(T? val) onChanged;

  RadioInputRowList({
    required this.groupValue,
    required this.values,
    required this.labels,
    required this.onChanged}
  ){
    assert(values.length != labels.length, "Por cada valor debe haber un descriptor, valores = ${values.length} , descriptores = ${labels.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values.asMap().entries.map((value) => RadioInput<T>(
        groupValue: groupValue,
        value: value.value,
        label: labels[value.key],
        onChanged: onChanged
      )).toList()
    );
  }
}