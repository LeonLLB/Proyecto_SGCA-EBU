import 'package:flutter/material.dart';

class DualRadioInputContainer extends StatefulWidget {
  final Map<String, String> labels;
  final IconData icono;
  final Function(String value) onChangeValue;

  DualRadioInputContainer(
      {required this.labels, required this.icono, required this.onChangeValue});

  @override
  _DualRadioInputContainerState createState() =>
      _DualRadioInputContainerState();
}

class _DualRadioInputContainerState extends State<DualRadioInputContainer> {
  String valor = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 4),
          color: Colors.grey[200]),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icono, size: 60),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Text(widget.labels['main']!),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio<String>(
                        value: widget.labels['val1']!,
                        groupValue: valor,
                        onChanged: (String? val) {
                          valor = val!;
                          widget.onChangeValue(val);
                        },
                      ),
                      Text(widget.labels['val1']!)
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio<String>(
                        value: widget.labels['val2']!,
                        groupValue: valor,
                        onChanged: (String? val) {
                          valor = val!;
                          widget.onChangeValue(val);
                        },
                      ),
                      Text(widget.labels['val2']!)
                    ])
              ],
            )
          ]),
    );
  }
}
