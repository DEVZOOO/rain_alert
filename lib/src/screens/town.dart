import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/models/import.dart';
import '/src/widgets/import.dart';
import '/src/providers/import.dart';
import '/src/controllers/import.dart' show TownController;

/// 우리동네 화면
class TownPage extends StatefulWidget {
  const TownPage({super.key});

  @override
  State<TownPage> createState() => _TownPageState();
}

class _TownPageState extends State<TownPage>
  with AutomaticKeepAliveClientMixin {  // 상태값 유지

  /// 선택지역코드
  late String _code;

  /// 최상위 지역 목록(시,도)
  late List<TownModel> _topLevelTownList;

  /// 지역별 날씨 리스트 - API 호출 덜하기 위해서
  final Map<String, List<WeatherViewModel>> _weatherList = {};

  late final TownController _townController;

  
  // 상태값 유지 여부
  @override
  bool get wantKeepAlive => true;


  // 위젯트리 초기화, 최초 한번만 실행됨
  @override
  void initState() {
    super.initState();
    _townController = TownController();

    initWidgetState();
  }

  /// widget state 초기화 작업
  void initWidgetState() {
    final List<TownModel> townList = context.read<StorageTownProvider>().townList;
    _code = townList.isEmpty ? '' : townList[0].code;

    // level1 초기화
    _townController.getTownList(1, null).then((value) => _topLevelTownList = value);
  }

  /// 날씨리스트 API 조회
  Future<List<WeatherViewModel>> _getWeatherList() async {
      /*
      List<WeatherViewModel> list = await Future.delayed(const Duration(seconds: 2), () {
        return [
          WeatherViewModel(date: '20240109', time: '1000'),
        ];
      });
      */
      List<WeatherViewModel> list = await _townController.getWeatherList(_code);
      return list;
  }

  /// 지역 추가 handler, 추가 모달 오픈
  void openTownSelectModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TownSelect(townListDept1: _topLevelTownList,),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    late Widget listWidget;
    // 최초 실행일때만 API call
    if (_weatherList.containsKey(_code)) {
      listWidget = Container(
          color: theme.colorScheme.background,
          child: WeatherInfoList(_weatherList[_code]!)
      );
    } else {
      listWidget = FutureBuilder<List<WeatherViewModel>>(
        future: _getWeatherList(),
        builder: (context, snapshot) {
          // 화면
          late Widget result;

          if (snapshot.hasData) {
            // 데이터 저장
            _weatherList[_code] = snapshot.data!;
            result = Container(
                color: theme.colorScheme.background,
                child: WeatherInfoList(snapshot.data!)
            );
          } else if (snapshot.hasError) {
            result = Center(
              child: Column(
                children: [
                  const Text('다시 시도해주세요.'),
                  TextButton(
                    onPressed: () {
                      initWidgetState();
                      setState((){});
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            result = const Center(child: CircularProgressIndicator(),);
          }

          return result;
        },
      );
    }

    return Column(
        children: [
          TownList(
            selectedTownCode: _code,
            clickHandler: (String code) { setState(() { _code = code; }); },
            openModalHandler: openTownSelectModal,
          ),
          Expanded(
            child: listWidget,
          ),
        ],
    );
  }
}
