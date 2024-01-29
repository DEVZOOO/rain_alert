/// 지역정보
class TownModel {
  /// 행정구역코드
  final String code;

  /// 1dept
  final String level1;
  /// 2dept
  final String? level2;
  /// 3dept
  final String? level3;

  final int level;

  /// nx
  final int x;
  /// ny
  final int y;

  TownModel({
    required this.code,
    required this.level1,
    this.level2,
    this.level3,
    required this.level,
    required this.x,
    required this.y,
  });

  /// Map to Model
  factory TownModel.fromJson(Map<String, dynamic> json) {
    TownModel model = TownModel(
      code: json["code"]!,
      level1: json["level1"]!,
      level2: json["level2"],
      level3: json["level3"],
      level: json["level"]!,
      x: json["x"]!,
      y: json["y"]!,
    );
    return model;
  }

}