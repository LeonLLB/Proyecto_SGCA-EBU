import 'package:flutter/material.dart';



class RadioInput<T> extends StatelessWidget {

  final T groupValue;
  final T value;
  final String label;
  final void Function(T? val) onChanged;

  RadioInput({
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
        Text(label)
      ],
    );
  }
}