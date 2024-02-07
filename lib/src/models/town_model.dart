/// 지역정보
class TownModel {
  final String code, level1, level2, level3;
  final int level, x, y;

  TownModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        level1 = json['level1'],
        level2 = json['level2'] ?? '',
        level3 = json['level3'] ?? '',
        level = json['level'],
        x = json['x'],
        y = json['y'];

  /// 지역명 조회 (A도/시 B군/구 C읍/면/동)
  String get townName => [
        for (final i in [level1, level2, level3])
          if (i != '') i,
      ].join(' ');

  @override
  String toString() {
    return 'code: $code, level1: $level1, level2: $level2, level3: $level3, level: $level, x: $x, y: $y';
  }
}
