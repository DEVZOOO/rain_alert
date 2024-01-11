/// 지역정보
class TownModel {
  /// 행정구역코드
  final String code;

  /// 1dept
  final String dept1;
  /// 2dept
  final String? dept2;
  /// 3dept
  final String? dept3;

  /// nx
  final int x;
  /// ny
  final int y;

  TownModel({
    required this.code,
    required this.dept1,
    this.dept2,
    this.dept3,
    required this.x,
    required this.y,
  });
}