import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rain_alert/src/models/select_town_model.dart';
import 'package:rain_alert/src/models/weather_model.dart';
import 'package:rain_alert/src/services/weather_service.dart';

class WeatherListWidget extends StatefulWidget {
  SelectTownModel selectTownModel;

  WeatherListWidget({
    super.key,
    required this.selectTownModel,
  });

  @override
  State<WeatherListWidget> createState() => _WeatherListWidgetState();
}

class _WeatherListWidgetState extends State<WeatherListWidget> {
  late Future<List<WeatherModel>> weatherListFuture;

  /// 최초 호출시 저장
  Map<String, List<WeatherModel>> storedWeatherMap = {};

  @override
  void initState() {
    super.initState();
    weatherListFuture =
        WeatherService.getWeatherList(widget.selectTownModel.townModel);
  }

  @override
  void didUpdateWidget(covariant WeatherListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    log('WeatherListWidget didUpdateWidget');

    final code = widget.selectTownModel.townModel!.code;
    if (!storedWeatherMap.containsKey(code)) {
      weatherListFuture =
          WeatherService.getWeatherList(widget.selectTownModel.townModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    log('WeatherListWidget build');
    final code = widget.selectTownModel.townModel!.code;

    return Column(
      children: [
        // TEST
        // Text(widget.selectTownModel.townModel?.code ?? ''),
        Expanded(
          child: storedWeatherMap.containsKey(code)
              ? WeatherWidget(list: storedWeatherMap[code]!)
              : FutureBuilder(
                  future: weatherListFuture,
                  builder: (context, snapshot) {
                    log('connectionState : ${snapshot.connectionState}');

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      final list = snapshot.data!;
                      storedWeatherMap[code] = list;
                      return WeatherWidget(list: list);
                    } else if (snapshot.hasError) {
                      return const Text('네트워크 에러');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.list,
  });

  final List<WeatherModel> list;

  /// 날짜 포맷팅하여 반환
  String _formatDate(DateTime date) {
    final hour = date.hour;
    final isPm = hour > 11; // 정오부터 오후
    // final String formattedDate = DateFormat('M월 d일 H시').format(dateTime);
    final String formattedDate =
        '${DateFormat('M월 d일').format(date)} ${isPm ? '오후 ${hour > 12 ? hour - 12 : hour}' : '오전 $hour'}시';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final weather = list[index];
        final date = weather.date;
        final time = weather.time;

        final dateTime = DateTime.parse('${date}T${time}00');
        final formattedDate = _formatDate(dateTime);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            boxShadow: [
              BoxShadow(
                color: colorScheme.onTertiaryContainer.withOpacity(.5),
                offset: const Offset(2, 2),
                blurRadius: 2,
              ),
            ],
            /*
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            */
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  // color: colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(weather.tmpFormat),
              Text(weather.popFormat),
              // Text(weather.ptyName),
              Tooltip(
                message: weather.ptyName,
                showDuration: const Duration(seconds: 1),
                triggerMode: TooltipTriggerMode.tap,
                child: weather.ptyIcon,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 13,
      ),
    );
  }
}
