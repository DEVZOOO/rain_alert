
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rain_alert/src/api/utils_api.dart';
import 'package:rain_alert/src/models/import.dart' show TownModel;
import 'package:test/test.dart';

void main() async {

  await dotenv.load(fileName: 'env/.env');

  test('Select Level 1 Town List', () {
    UtilsApi api = UtilsApi();

    api.getTownInfoList(1, null).then((v) => {
    });
  });
}