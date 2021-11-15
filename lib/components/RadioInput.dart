import 'package:flutter/material.dart';



class RadioInput<T> extends StatelessWidget {

  final T groupValue;
  final T value;
  final String label;
  final void Function(T? val) onChanged;
  final bool? enabled;

  RadioInput({
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChanged,
    this.enabled : true
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: (val){
            if(enabled!){onChanged(val);}
          }
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
        Text(label)
      ],
    );
  }
}