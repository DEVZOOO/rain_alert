import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rain_alert/src/models/town_model.dart';

/// town_screen에서 선택한 지역 코드
class SelectTownModel extends ChangeNotifier {
  TownModel? _townModel;

  TownModel? get townModel => _townModel;

  void updateSelectTownCode(TownModel townModel) {
    log('updateSelectTownCode!');
    _townModel = townModel;
    notifyListeners();
  }
}
