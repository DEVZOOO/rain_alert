
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/src/models/import.dart';

/// 날씨정보리스트
class WeatherInfoList extends StatelessWidget {
  const WeatherInfoList({super.key, weatherInfoList})
    : _weatherInfoList = weatherInfoList;

  final List<WeatherViewModel> _weatherInfoList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('시간')),
          DataColumn(label: Text('기온')),
          DataColumn(label: Text('강수확률')),
          DataColumn(label: Text('강수형태')),
        ],
        rows: _weatherInfoList.map((e) {
          final String date = e.date;
          final String time = e.time;

          final DateTime dateTime = DateTime.parse('${date}T${time}00');
          final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

          return DataRow(
            cells: [
              DataCell(Text(formattedDate, textAlign: TextAlign.center,)),
              DataCell(Text(e.tmpFormat, textAlign: TextAlign.center,)),
              DataCell(Text(e.popFormat, textAlign: TextAlign.center,)),
              DataCell(Text(e.ptyName, textAlign: TextAlign.center,)),
            ],
          );
        }).toList(),
      ),
    );
  }
}