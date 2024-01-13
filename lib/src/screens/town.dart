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

  final TownController _townController = TownController();
  
  /// 선택한 지역정보
  TownModel? _townInfo;

  /// 최상위 지역 목록(시,도)
  late List<TownModel> _topLevelTownList;

  /// 지역별 날씨 리스트 {'code': []} - API 호출 덜하기 위함
  late final Map<String, List<WeatherViewModel>> _weatherList;

  
  // 상태값 유지 여부
  @override
  bool get wantKeepAlive => true;


  // 위젯트리 초기화, 최초 한번만 실행됨
  @override
  void initState() {
    super.initState();
    _initWidgetState();
  }

  /// widget state 초기화 작업
  void _initWidgetState() {
    // final List<TownModel> townList = context.watch<StorageTownProvider>().townList;
    // _townInfo = townList.isEmpty ? null : townList[0];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<TownModel> list = context.read<StorageTownProvider>().townList;
      if (list.isNotEmpty) {
        setState(() {
           _townInfo = list[0];
        });
      }
    });

    // level1 초기화
    _townController.getTownList(1, null).then((value) => _topLevelTownList = value);

    _weatherList = {};
  }

  /// 날씨리스트 API 조회
  Future<List<WeatherViewModel>> _getWeatherList() async {
    // TEST 데이터
    /*
    List<WeatherViewModel> list = await Future.delayed(const Duration(seconds: 5), () {
      return [
        WeatherViewModel(date: '20240109', time: '1000'),
      ];
    });
    */
    List<WeatherViewModel> list = await _townController.getWeatherList(_townInfo);
    return list;
  }

  /// 지역 추가 handler, 추가 모달 오픈
  void _openTownSelectModal() {
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

    // final theme = Theme.of(context);

    late Widget listWidget;

    String code = _townInfo != null ? _townInfo!.code : '';

    // 최초 실행일때만 API call
    if (_weatherList.containsKey(code)) {
      listWidget = WeatherInfoList(weatherInfoList: _weatherList[code]!);
    } else {
      listWidget = FutureBuilder<List<WeatherViewModel>>(
        future: _getWeatherList(),
        builder: (context, snapshot) {
          // 화면
          late Widget result;

          if (snapshot.hasData && snapshot.data != null) {
            // 데이터 정상 조회

            // 데이터 저장
            _weatherList[code] = snapshot.data!;
            result = WeatherInfoList(weatherInfoList: snapshot.data!);
          } else if (snapshot.hasError) {
            // 에러발생

            result = Center(
              child: Column(
                children: [
                  const Text('다시 시도해주세요.'),
                  TextButton(
                    onPressed: () {
                      _initWidgetState();
                      setState((){});
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            // 작업 진행중

            result = const Center(child: CircularProgressIndicator(),);
          }

          return result;
        },
      );
    }

    return Column(
        children: [
          TownList(
            selectedTownCode: _townInfo?.code ?? '',
            clickHandler: (TownModel townInfo) { setState(() { _townInfo = townInfo; }); },
            openModalHandler: _openTownSelectModal,
          ),
          Expanded(
            child: listWidget,
          ),
        ],
    );
  }
}
