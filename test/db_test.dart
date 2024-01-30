
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rain_alert/src/services/import.dart';
import 'package:test/test.dart';

void main() async {

  await dotenv.load(fileName: 'env/.env');
  
  test('Select Test', () {
    TownService service = TownService();
    service.getTownList(2, '11').then((value) => print('$value'));
  });
}