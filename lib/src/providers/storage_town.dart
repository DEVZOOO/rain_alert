import 'package:flutter/material.dart';
import '/src/models/import.dart';

/// 저장된 지역 리스트
class StorageTownProvider extends ChangeNotifier {
  List<TownModel> _townList = [];

  /// constructor
  StorageTownProvider() {
    // TEST code
    _townList = [
      TownModel(code: '1165000000', dept1: '서울특별시', dept2: '서초구', dept3: '', x: 61, y: 125),
      TownModel(code: '1168000000', dept1: '서울특별시', dept2: '강남구', dept3: '', x: 61, y: 126),
    ];
  }


  /// 지역 추가
  void insertTown(TownModel town) {
    _townList.add(town);
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

    notifyListeners();
  }

  /// 지역 객체[TownModel]로 지역 삭제
  void deleteTownViaObj(TownModel t) {
    _townList.remove(t);
    notifyListeners();
  }

  List<TownModel> get townList => _townList;
}