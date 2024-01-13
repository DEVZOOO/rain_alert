import 'dart:developer';

import '/src/models/import.dart';

/// town_info repository
class TownInfoRepository {

    /// TEST용 데이터, TODO - REST API 처리?
    final TOWN_LIST = <TownModel>[
    /*
    TownModel(code: '1162000000', level1: '서울특별시', level2: '관악구', level3: '', x: 59, y: 125),
    TownModel(code: '1165000000', level1: '서울특별시', level2: '서초구', level3: '', x: 61, y: 125),
    TownModel(code: '1168000000', level1: '서울특별시', level2: '강남구', level3: '', x: 61, y: 126),
    TownModel(code: '1171000000', level1: '서울특별시', level2: '송파구', level3: '', x: 62, y: 126),
    */

    TownModel(code: '1100000000', level1: '서울특별시', level2: '', level3: '', x: 60, y: 127),
    TownModel(code: '2600000000', level1: '부산광역시', level2: '', level3: '', x: 98, y: 76),
    TownModel(code: '1168000000', level1: '서울특별시', level2: '강남구', level3: '', x: 61, y: 126),
    TownModel(code: '1171000000', level1: '서울특별시', level2: '송파구', level3: '', x: 62, y: 126),
    TownModel(code: '2614000000', level1: '부산광역시', level2: '서구', level3: '', x: 97, y: 74),
    TownModel(code: '2629000000', level1: '부산광역시', level2: '남구', level3: '', x: 98, y: 75),
    TownModel(code: '1168051000', level1: '서울특별시', level2: '강남구', level3: '신사동', x: 61, y: 126),
    TownModel(code: '1171053100', level1: '서울특별시', level2: '송파구', level3: '거여1동', x: 63, y: 125),
    TownModel(code: '2614061500', level1: '부산광역시', level2: '서구', level3: '아미동', x: 97, y: 74),
    TownModel(code: '2629061000', level1: '부산광역시', level2: '남구', level3: '용당동', x: 98, y: 74),
  ];

  /// [level]레벨이고 부모 코드가 [parentCode]인 지역 리스트 조회
  List<TownModel> getTownInfoList(int level, String? parentCode) {
    List<TownModel> list = [];

    String trimCode = parentCode != null ? parentCode.replaceAll(RegExp('0+\$'), '') : '';

    log('trimCode : $trimCode');
    log('parent code : $trimCode');

    // TODO - DB처리, DB에는 각 row의 level 저장
    switch (level) {
      case 1:
        for (TownModel item in TOWN_LIST) {
          if (item.level2 == '') {
            list.add(item);
          }
        }
        break;
      case 2:
        if (trimCode != '') {
          for (TownModel item in TOWN_LIST) {
            if (item.level3 == '' && item.code.startsWith(trimCode)) {
              list.add(item);
            }
          }
        }
        
        break;
      case 3:
        if (trimCode != '') {
          for (TownModel item in TOWN_LIST) {
            if (item.level3 != '' && item.code.startsWith(trimCode)) {
              list.add(item);
            }
          }
        }
        
        break;
      default:
        throw Exception('Invalid level $level');
    }
    
    return list;
  }
  
}