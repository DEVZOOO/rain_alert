import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/config/env.dart';
import '/src/models/import.dart';
import '/src/api/import.dart';

/// 저장된 지역 리스트
class StorageTownProvider extends ChangeNotifier {
  late final SharedPreferences prefs;
  /// localStorage key
  final String KEY = env.localStorageKey;

  /// localStorage 저장용 데이터
  late final List<String> codeList;
  
  List<TownModel> _townList = [];

  /// constructor
  StorageTownProvider() {
    /*
    // TEST code
    _townList = [
      TownModel(code: '1165000000', level1: '서울특별시', level2: '서초구', level3: '', x: 61, y: 125, level: 2,),
      TownModel(code: '1168000000', level1: '서울특별시', level2: '강남구', level3: '', x: 61, y: 126, level: 2,),
    ];
    */

    _init();
    
  }

  void _init() async {
    prefs = await SharedPreferences.getInstance();
    codeList = prefs.getStringList(KEY) ?? [];

    if (codeList.isNotEmpty) {
      UtilsApi api = UtilsApi();
      List<TownModel> result = await api.getTownInfoDetailList(codeList);
      _townList = result;

      notifyListeners();  // 생성자에서는 async 안댐?
    }
  }


  /// 지역 추가
  void insertTown(TownModel town) {
    _townList.add(town);
    codeList.add(town.code);

    prefs.setStringList(KEY, codeList);

    notifyListeners();
  }

  /// 지역 코드 [code]로 지역 삭제
  void deleteTownViaCode(String code) {
    for (TownModel t in _townList) {
      if (t.code == code) {
        _townList.remove(t);
        break;
      }
    }

    codeList.remove(code);

    prefs.setStringList(KEY, codeList);

    notifyListeners();
  }

  /// 지역 객체[TownModel]로 지역 삭제
  void deleteTownViaObj(TownModel t) {
    _townList.remove(t);
    codeList.remove(t.code);

    prefs.setStringList(KEY, codeList);

    notifyListeners();
  }

  List<TownModel> get townList => _townList;
}