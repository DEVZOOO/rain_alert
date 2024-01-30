import 'package:test/test.dart';
import 'package:intl/intl.dart';

void main() {
  test('Date Format Test', () {
    /*
    String dateStr = '20240105T150000';
    DateTime dateTime = DateTime.parse(dateStr);
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    print(dateTime);
    print(formatter);
    */

    DateTime now = DateTime.now();

    // 지금 시간이 40분 전이면 시간 - 1
    if (now.minute < 40) {
      now.subtract(const Duration(hours: 1));
    }

    String nowDate = DateFormat('yyyyMMdd').format(now);
    String nowTime = '${DateFormat('HH').format(now)}00';

    print(now);
    print(nowDate);
    print(nowTime);
    
  });
}