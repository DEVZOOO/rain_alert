import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rain_alert/src/config/env.dart';

import 'package:rain_alert/src/models/town_model.dart';
import 'package:rain_alert/src/models/weather_model.dart';

class WeatherService {
  static final WEATHER_API_URL = env.weatherApiUrl;
  static final WEATHER_API_KEY = env.weatherApiKey;

  /// 지역 날씨 리스트 조회
  static Future<List<WeatherModel>> getWeatherList(TownModel? town) async {
    log('search town :: $town');
    // TEST
    return Future.delayed(
      const Duration(seconds: 3),
      () => [
        WeatherModel.fromJson({
          'date': '2024-02-03',
          'time': '15:00',
          'tmp': '10',
          'pop': '60',
          'pty': '2',
        }),
        WeatherModel.fromJson({
          'date': '2024-02-04',
          'time': '03:00',
          'tmp': '10',
          'pop': '60',
          'pty': '3',
        }),
        WeatherModel.fromJson({
          'date': '2024-02-04',
          'time': '11:00',
          'tmp': '10',
          'pop': '60',
          'pty': '1',
        }),
        WeatherModel.fromJson({
          'date': '2024-02-04',
          'time': '12:00',
          'tmp': '10',
          'pop': '60',
          'pty': '1',
        }),
        WeatherModel.fromJson({
          'date': '2024-02-04',
          'time': '13:00',
          'tmp': '10',
          'pop': '60',
          'pty': '4',
        }),
        WeatherModel.fromJson({
          'date': '2024-02-04',
          'time': '23:00',
          'tmp': '5',
          'pop': '10',
          'pty': '4',
        }),
      ],
    );

    /*
    List<WeatherModel> list = [];

    if (town == null) {
      return list;
    }

    DateTime now = DateTime.now().add(const Duration(hours: 9)); // UTC to KST

    // 지금 시간이 10분 전이면 시간 - 1
    if (now.minute < 10) {
      now.subtract(const Duration(hours: 1));
    }

    // base_time 설정
    // 3n + 2
    // hour / 3 몫 - 1을 n에 넣음
    // ex) 10시 > 10 / 3 = 3 > (3 - 1) * 3 + 2 = 8
    // ex) 19시 > 19 / 3 = 6 > (6 - 1)  * 3 + 2 = 17
    String baseTime =
        '${((now.hour ~/ 3 - 1) * 3 + 2).toString().padLeft(2, '0')}00';
    String nowDate = DateFormat('yyyyMMdd').format(now);

    // make param
    Map<String, String> params = {
      'ServiceKey': WEATHER_API_KEY,
      'dataType': 'JSON',
      'base_date': nowDate,
      'base_time': baseTime,
      'pageNo': '1',
      'numOfRows': '1000',
      'nx': town.x.toString(),
      'ny': town.y.toString(),
    };

    final url = Uri.parse(WEATHER_API_URL).replace(queryParameters: params);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 성공시
      final res = jsonDecode(response.body)['response'];
      final header = res['header'];

      if (header['resultCode'] == '00') {
        final body = res['body'];
        final itemList = body['items']['item'];

        Map<String, String> dto = {};
        for (var e in itemList) {
          String key = e['category'] as String;
          String value = e['fcstValue'] as String;

          String date = e['fcstDate'] as String;
          String time = e['fcstTime'] as String;

          if (dto.containsKey('date') && dto['date']!.compareTo(date) != 0 ||
              dto.containsKey('time') && dto['time']!.compareTo(time) != 0) {
            list.add(WeatherModel.fromJson(dto));
            dto = {};
          }

          dto[key.toLowerCase()] = value;
          dto['date'] = date;
          dto['time'] = time;
        }

        list = list
            .where(
                (element) => element.pop != null && int.parse(element.pop!) > 0)
            .toList();
      }

      return list;
    }

    throw Error();
    */
  }
}
