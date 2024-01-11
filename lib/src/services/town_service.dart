import 'dart:developer';
import '/src/api/import.dart';

import '/src/models/import.dart';

/// 우리동네 관련 service
class TownService {

  final TOWN_LIST = <TownModel>[
    /*
    TownModel(code: '1162000000', dept1: '서울특별시', dept2: '관악구', dept3: '', x: 59, y: 125),
    TownModel(code: '1165000000', dept1: '서울특별시', dept2: '서초구', dept3: '', x: 61, y: 125),
    TownModel(code: '1168000000', dept1: '서울특별시', dept2: '강남구', dept3: '', x: 61, y: 126),
    TownModel(code: '1171000000', dept1: '서울특별시', dept2: '송파구', dept3: '', x: 62, y: 126),
    */

    TownModel(code: '1100000000', dept1: '서울특별시', dept2: '', dept3: '', x: 60, y: 127),
    TownModel(code: '2600000000', dept1: '부산광역시', dept2: '', dept3: '', x: 98, y: 76),
    TownModel(code: '1168000000', dept1: '서울특별시', dept2: '강남구', dept3: '', x: 61, y: 126),
    TownModel(code: '1171000000', dept1: '서울특별시', dept2: '송파구', dept3: '', x: 62, y: 126),
    TownModel(code: '2614000000', dept1: '부산광역시', dept2: '서구', dept3: '', x: 97, y: 74),
    TownModel(code: '2629000000', dept1: '부산광역시', dept2: '남구', dept3: '', x: 98, y: 75),
    TownModel(code: '1168051000', dept1: '서울특별시', dept2: '강남구', dept3: '신사동', x: 61, y: 126),
    TownModel(code: '1171053100', dept1: '서울특별시', dept2: '송파구', dept3: '거여1동', x: 63, y: 125),
    TownModel(code: '2614061500', dept1: '부산광역시', dept2: '서구', dept3: '아미동', x: 97, y: 74),
    TownModel(code: '2629061000', dept1: '부산광역시', dept2: '남구', dept3: '용당동', x: 98, y: 74),
  ];

  final WeatherApi _weatherApi = WeatherApi();

  /// 지역 데이터 조회, TODO - REST API 처리?
  Future<List<TownModel>> getTownList(int level, String? parentCode) async {
    List<TownModel> list = [];

    String trimCode = parentCode != null ? parentCode.replaceAll(RegExp('0+\$'), '') : '';

    log('trimCode : $trimCode');
    log('parent code : $trimCode');

    // TODO - DB처리, DB에는 각 row의 level 저장
    switch (level) {
      case 1:
        for (TownModel item in TOWN_LIST) {
          if (item.dept2 == '') {
            list.add(item);
          }
        }
        break;
      case 2:
        for (TownModel item in TOWN_LIST) {
          if (item.dept3 == '' && item.code.startsWith(trimCode)) {
            list.add(item);
          }
        }
        break;
      case 3:
        for (TownModel item in TOWN_LIST) {
          if (item.dept3 != '' && item.code.startsWith(trimCode)) {
            list.add(item);
          }
        }
        break;
      default:
        throw Exception('Invalid level $level');
    }
    
    return list;
  }


  /// 날씨리스트 조회
  Future<List<WeatherViewModel>> getWeatherList(String code) {
    // code로 nx, ny 구하기,  TODO - DB or REST API 처리?
    // int? nx;
    // int? ny;


    TownModel? townInfo;
    for (TownModel m in TOWN_LIST) {
      if (m.code == code) {
        // nx = m.x;
        // ny = m.y;
        townInfo = m;
        break;
      }
    }

    if (townInfo == null) {
      throw Exception('Invalid code.');
    }

    return _weatherApi.getWeatherList(townInfo);

  }
  
}

