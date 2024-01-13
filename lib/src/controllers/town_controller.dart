import '/src/models/import.dart';
import '/src/services/import.dart';

/// 지역 controller
class TownController {

  final TownService _townService = TownService();

  /// 특정 레벨 지역리스트 조회
  Future<List<TownModel>> getTownList(int level, String? parentCode) {
    return _townService.getTownList(level, parentCode);
  }

  /*
  /// 날씨리스트 조회
  Future<List<WeatherViewModel>> getWeatherList(String code) {
    return code == '' ? Future(() => []) : _townService.getWeatherList(code);
  }
  */

  /// 날씨리스트 조회
  Future<List<WeatherViewModel>> getWeatherList(TownModel? townInfo) {
    return townInfo == null ? Future(() => []) : _townService.getWeatherList(townInfo);
  }
}