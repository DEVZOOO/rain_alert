import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherModel {
  /// 날짜 yyyymmdd
  final String date;

  /// 시간 hhii
  final String time;

  /// 1시간 기온
  final String? _tmp;

  /// 풍속(동서성분)
  final String? uuu;

  /// 풍속(남북성분)
  final String? vvv;

  /// 강수확률
  final String? _pop;

  /// 강수형태
  final String? _pty;

  /// 1시간 강수량
  final String? pcp;

  /// 하늘상태
  final String? sky;

  WeatherModel.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        time = json['time'],
        _tmp = json['tmp'],
        uuu = json['uuu'],
        vvv = json['vvv'],
        _pop = json['pop'],
        _pty = json['pty'],
        pcp = json['pcp'],
        sky = json['sky'];

  String? get pop => _pop;
  String? get pty => _pty;

  /// 1시간 기온 섭씨 기호 포맷팅 ex) [_tmp]℃
  String get tmpFormat => _tmp == null ? '' : '$_tmp℃';

  /// 강수확률 퍼센트 기호 포맷팅 ex) [_pop]%
  String get popFormat => _pop == null ? '' : '$_pop%';

  /// 강수형태 코드 > 명칭 포맷팅 ex) 소나기
  String get ptyName => _pty == null ? '' : _getPtyCode(int.parse(_pty));

  Widget get ptyIcon =>
      _pty == null ? Container() : BoxedIcon(_getPtyIcon(int.parse(_pty)));

  /// 강수형태별 아이콘
  IconData _getPtyIcon(int code) {
    IconData icon;

    switch (code) {
      case 1:
        icon = WeatherIcons.rain;
        break;
      case 2:
        icon = WeatherIcons.rain_mix;
        break;
      case 3:
        icon = WeatherIcons.snow;
        break;
      case 4:
        icon = WeatherIcons.showers;
        break;
      default:
        icon = WeatherIcons.na;
    }

    return icon;
  }

  /// 강수형태 코드별 상태
  String _getPtyCode(int code) {
    late String name;

    switch (code) {
      case 1:
        name = '비';
        break;
      case 2:
        name = '비/눈';
        break;
      case 3:
        name = '눈';
        break;
      case 4:
        name = '소나기';
        break;
      default:
        name = '';
    }

    return name;
  }
}
