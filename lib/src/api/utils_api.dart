import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '/src/config/env.dart';
import '/src/models/import.dart' show TownModel;

/// Custom REST API
/// TODO - token 추가
class UtilsApi {
  final String _API_URL = env.utilsApiUrl;

  Future<List<TownModel>> getTownInfoList(int level, String? parentCode) async {
    List<TownModel> list = [];

    String? trimCode = parentCode?.replaceAll(RegExp('0+\$'), '');

    var url = Uri.parse('$_API_URL/list').replace(queryParameters: {
      'level' : level.toString(),
      'parentCode' : trimCode,
    });

    var res = await http.get(url);

    if (res.statusCode == 200) {
      var response = json.decode(res.body)['data'];
      for (var e in response) {
        list.add(TownModel.fromJson(e));
      }

    } else {
      var response = json.decode(res.body)['data'];
      log(".......... Fail to call REST API :: $response");
    }

    return list;
    
  }

  /// 특정 다중 지역 상세정보 조회
  Future<List<TownModel>> getTownInfoDetailList(List<String> codeList) async {
    List<TownModel> list = [];

    var url = Uri.parse('$_API_URL/detail').replace(queryParameters: {
      'codeList' : codeList,
    });

    var res = await http.get(url);

    if (res.statusCode == 200) {
      var response = json.decode(res.body)['data'];
      for (var e in response) {
        list.add(TownModel.fromJson(e));
      }

    } else {
      var response = json.decode(res.body)['data'];
      log(".......... Fail to call REST API :: $response");
    }

    return list;
  }

}