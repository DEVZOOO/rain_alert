import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/src/models/import.dart';

import '/src/services/town_service.dart';
import '/src/widgets/import.dart';

/// 우리동네 화면
class TownPage extends StatefulWidget {

  @override
  State<TownPage> createState() => _TownPageState();
}

class _TownPageState extends State<TownPage>
with AutomaticKeepAliveClientMixin {  // 상태값 유지
  final TownService townService = TownService();

  /// 선택지역코드
  late String _selectedTownCode;

  // 초기화
  @override
  void initState() {
    super.initState();
    final List<TownModel> townList = context.read<StorageTownProvider>().townList;
    _selectedTownCode = townList.isEmpty ? '0' : townList[0].code;
  }

  // 상태값 유지 여부
  @override
  bool get wantKeepAlive => true;

  /// 날씨리스트 API 조회
  Future<List<WeatherViewModel>> getWeatherList() async {
      List<WeatherViewModel> list = await townService.getWeatherList(_selectedTownCode);
      return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    // Future<List<WeatherViewModel>> listFuture = getWeatherList();
    Future<List<WeatherViewModel>> listFuture = Future.delayed(const Duration(seconds: 2), () {
        return [];
      });

    return Column(
        children: [
          TownList(_selectedTownCode, (String code) { setState(() { _selectedTownCode = code; }); }),
          Expanded(
            child: FutureBuilder<List<WeatherViewModel>>(
              future: listFuture,
              builder: (context, snapshot) {
                return (snapshot.hasData
                  ? Container(
                      color: theme.colorScheme.background,
                      child: WeatherInfoList(snapshot.data!)
                  )
                  : snapshot.hasError
                  ? const Center(child: Text('다시 시도해주세요.'),)
                  : const Center(child: CircularProgressIndicator(),)
                );
              },
            ),
          ),
        ],
    );
  }
}
