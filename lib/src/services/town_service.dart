import '/src/models/import.dart';
import '/src/api/import.dart';

/// 우리동네 관련 service
class TownService {

  final UtilsApi _utilsApi = UtilsApi();
  final WeatherApi _weatherApi = WeatherApi();

  /// 지역 데이터 조회
  Future<List<TownModel>> getTownList(int level, String? parentCode) async {
    return _utilsApi.getTownInfoList(level, parentCode);
  }

  /*
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
  */


  /// 날씨리스트 조회
  Future<List<WeatherViewModel>> getWeatherList(TownModel? townInfo) {
    if (townInfo == null) {
      throw Exception('Invalid code.');
    }

    return _weatherApi.getWeatherList(townInfo);

  }
  
}

