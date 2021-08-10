import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  final Widget body;
  final Widget icon;
  MenuContainer({required this.body, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [icon, body],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 4),
          color: Colors.grey[200]),
    );
  }
}
