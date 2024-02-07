import 'package:flutter/material.dart';
import 'package:rain_alert/src/config/env.dart';
import 'package:rain_alert/src/models/town_model.dart';
import 'package:rain_alert/src/services/town_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoredTownModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  List<TownModel> towns = [];

  StoredTownModel() {
    init();
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    final storedTownsInstance = _prefs.getStringList(env.localStorageKey);
    if (storedTownsInstance != null) {
      towns = await TownService.getTownDetailList(storedTownsInstance);
      notifyListeners();
    }
  }

  /// [code] 지역 추가
  void addTownCode(String code) async {
    TownModel t = await TownService.getTownDetail(code);
    addTownModel(t);
  }

  /// [TownModel] 지역 추가
  void addTownModel(TownModel t) async {
    towns.add(t);
    await _prefs.setStringList(
        env.localStorageKey, towns.map((e) => e.code).toList());
    notifyListeners();
  }

  /// [code] 지역 삭제
  void deleteTownCode(String code) {
    TownModel t = towns.firstWhere((element) => element.code == code);
    deleteTownModel(t);
  }

  /// [TownModel] 지역 삭제
  void deleteTownModel(TownModel t) async {
    towns.removeWhere((element) => element.code == t.code);
    await _prefs.setStringList(
        env.localStorageKey, towns.map((e) => e.code).toList());
    notifyListeners();
  }
}
