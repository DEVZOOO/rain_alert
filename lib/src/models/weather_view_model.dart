
class WeatherViewModel {
  /// 날짜 yyyymmdd
  String date;
  /// 시간 hhii
  String time;

  /// 1시간 기온
  String? _tmp;
  /// 풍속(동서성분)
  String? uuu;
  /// 풍속(남북성분)
  String? vvv;
  /// 강수확률
  String? _pop;
  /// 강수형태
  String? _pty;
  /// 1시간 강수량
  String? pcp;
  /// 하늘상태
  String? sky;

  WeatherViewModel({
    required this.date,
    required this.time,
    tmp,
    this.uuu,
    this.vvv,
    pop,
    pty,
    this.pcp,
    this.sky,
  })
    : _tmp = tmp
     , _pop = pop
     , _pty = pty
    ;

  factory WeatherViewModel.fromJson(Map<String, String> json) => WeatherViewModel(
    date: json['date']!,
    time: json['time']!,
    tmp: json['TMP'],
    uuu: json['UUU'],
    vvv: json['VVV'],
    pop: json['POP'],
    pty: json['PTY'],
    pcp: json['PCP'],
    sky: json['KSY'],
  );

  String? get pop => _pop;
  String? get pty => _pty;

  /// 1시간 기온 섭씨 기호 포맷팅 ex) [_tmp]℃
  String get tmpFormat => _tmp == null ? '' : '$_tmp℃';
  /// 강수확률 퍼센트 기호 포맷팅 ex) [_pop]%
  String get popFormat => _pop == null ? '' : '$_pop%';
  /// 강수형태 코드 > 명칭 포맷팅 ex) 소나기
  String get ptyName => _pty == null ? '' : _getPtyCode(int.parse(_pty!));

  /*
  factory WeatherViewModel.fromList(List<Map<String, String>> json) {
    WeatherViewModel model = WeatherViewModel();
    for (Map<String, String> item in json) {
      switch (item['category']) {
        case 'TMP' :
          model.tmp = item['fcstValue'];
          break;
        case 'UUU' :
          model.uuu = item['fcstValue'];
          break;
        case 'VVV' :
          model.vvv = item['fcstValue'];
          break;
      }
    } // END for

    return model;
  }
  */

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