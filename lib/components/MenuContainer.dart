import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  final List<Widget> body;
  final Widget icon;
  final CrossAxisAlignment alignment;
  MenuContainer(
      {required this.body,
      required this.icon,
      this.alignment: CrossAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: alignment,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ...body,
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 4),
          color: Colors.grey[200]),
    );
  }
}
