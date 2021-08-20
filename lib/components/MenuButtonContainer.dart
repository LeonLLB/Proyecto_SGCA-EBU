import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/MenuContainer.dart';

class MenuButtonContainer extends StatelessWidget {
  final Map<String, String> texts;
  final IconData icon;
  final Function() onPressed;

  MenuButtonContainer(
      {required this.texts, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: MenuContainer(
          body: [
            Text(texts['label']!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.symmetric(vertical: 2.5))
          ],
          icon: Icon(icon, size: 32, color: Colors.black),
          height: 60,
        ));
  }
}
