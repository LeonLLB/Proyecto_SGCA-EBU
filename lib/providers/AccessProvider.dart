import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccessProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _rol = 'admin';

  String get rol => _rol;

  void changeRol(String rol) => _rol = rol;
}
