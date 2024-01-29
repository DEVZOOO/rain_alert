import 'package:flutter/material.dart';

class SelectTownProvider extends ChangeNotifier {
  String _code = '';

  void changeCode(String code) {
    _code = code;
    notifyListeners();
  }

  String get code => _code;
}