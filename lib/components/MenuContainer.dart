import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  final List<Widget> body;
  final Widget icon;
  final CrossAxisAlignment alignment;
  final double height;
  MenuContainer(
      {required this.body,
      required this.icon,
      this.alignment: CrossAxisAlignment.center,
      this.height: 110});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon,
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: alignment,
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ...body,
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ],
            ),
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
