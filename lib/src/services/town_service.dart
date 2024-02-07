import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rain_alert/src/config/env.dart';
import 'package:rain_alert/src/models/town_model.dart';

class TownService {
  static final _UTILS_API_URL = env.utilsApiUrl;
  static const _list = 'list';
  static const _detail = 'detail';

  /// 지역 상세정보 조회
  static Future<TownModel> getTownDetail(String code) async {
    TownModel townInstance;
    final url = Uri.parse('$_UTILS_API_URL/$code');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = jsonDecode(response.body);
      final Map<String, dynamic> data = res['data'];
      townInstance = TownModel.fromJson(data);

      return townInstance;
    }

    throw Error();
  }

  /// 지역들 상세정보 조회
  static Future<List<TownModel>> getTownDetailList(List<String> codes) async {
    List<TownModel> townsInstances = [];

    if (codes.isEmpty) {
      return townsInstances;
    }

    final url = Uri.parse('$_UTILS_API_URL/$_detail').replace(queryParameters: {
      'codeList': codes,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = jsonDecode(response.body);
      final List<dynamic> data = res['data'];

      for (final d in data) {
        townsInstances.add(TownModel.fromJson(d));
      }

      return townsInstances;
    }

    throw Error();
  }

  /// 특정 레벨 지역 리스트 조회
  static Future<List<TownModel>> getTownList(
      int level, String? parentCode) async {
    List<TownModel> list = [];

    if (level > 1 && parentCode == null) {
      return list;
    }

    // String? trimCode = parentCode?.replaceAll(RegExp('0+\$'), '');
    String? trimCode = level == 2
        ? parentCode?.substring(0, 2)
        : parentCode?.replaceAll(RegExp('0+\$'), '');

    final url = Uri.parse('$_UTILS_API_URL/$_list').replace(queryParameters: {
      'level': level.toString(),
      if (level > 1 && trimCode != null) 'parentCode': trimCode,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = jsonDecode(response.body);
      final List<dynamic> data = res['data'];

      for (final d in data) {
        list.add(TownModel.fromJson(d));
      }

      return list;
    }

    throw Error();
  }
}
