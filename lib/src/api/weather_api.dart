import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:developer';

import '/src/config/env.dart';
import '/src/models/import.dart';

class WeatherApi {
  
  /// 특정 지역 날씨 조회 API call, TODO - REST API 처리?
  Future<List<WeatherViewModel>> getWeatherList(TownModel townInfo) async {
    List<WeatherViewModel> result = [];

    DateTime now = DateTime.now().add(const Duration(hours: 9));  // UTC to KST

    // 지금 시간이 10분 전이면 시간 - 1
    if (now.minute < 10) {
      now.subtract(const Duration(hours: 1));
    }

    // base_time 설정
    // 3n + 2
    // hour / 3 몫 - 1을 n에 넣음
    // ex) 10시 > 10 / 3 = 3 > (3 - 1) * 3 + 2 = 8
    // ex) 19시 > 19 / 3 = 6 > (6 - 1)  * 3 + 2 = 17
    String baseTime = '${((now.hour ~/ 3 - 1) * 3 + 2).toString().padLeft(2, '0')}00';
    String nowDate = DateFormat('yyyyMMdd').format(now);

    try {

      // make param
      Map<String, String> params = {
        'ServiceKey' : env.weatherApiKey,
        'dataType' : 'JSON',
        'base_date' : nowDate,
        'base_time' : baseTime,
        'pageNo' : '1',
        'numOfRows' : '1000',
        'nx' : townInfo.x.toString(),
        'ny' : townInfo.y.toString(),
      };

      var url = Uri.parse(env.weatherApiUrl);
      url = url.replace(queryParameters: params);

      log('=========== call weather API START');
      var res = await http.get(url, headers: params);

      if (res.statusCode == 200) {
        // 성공시
        var response = json.decode(res.body)['response'];
        var header = response['header'];
        if (header['resultCode'] == '00') {
          var body = response['body'];
          var itemList = body['items']['item'];
          
          Map<String, String> dto = {};
          for (var e in itemList) {
            String key = e['category'] as String;
            String value = e['fcstValue'] as String;

            String date = e['fcstDate'] as String;
            String time = e['fcstTime'] as String;

            if(
              dto.containsKey('date') && dto['date']!.compareTo(date) != 0
              || dto.containsKey('time') && dto['time']!.compareTo(time) != 0
            ) {

              WeatherViewModel vo = WeatherViewModel.fromJson(dto);
              result.add(vo);

              dto = {};
            }

            dto[key] = value;
            dto['date'] = date;
            dto['time'] = time;

          }

          result = result.where((element) => element.pop != null && int.parse(element.pop!) > 0).toList();
        }
        
      } else {
        log('=========== FAIL weather API : $res');
      }

      log('=========== call weather API END');
      
    } catch(e) {
      log(e.toString());
    }

    return result;
  }
}