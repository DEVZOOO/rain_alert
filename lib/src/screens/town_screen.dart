import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/src/config/env.dart';
import 'package:rain_alert/src/models/select_town_model.dart';
import 'package:rain_alert/src/models/stored_town_model.dart';
import 'package:rain_alert/src/models/town_model.dart';
import 'package:rain_alert/src/models/weather_model.dart';
import 'package:rain_alert/src/screens/add_town_modal_screen.dart';
import 'package:rain_alert/src/services/town_service.dart';
import 'package:rain_alert/src/services/weather_service.dart';
import 'package:rain_alert/src/widgets/weather_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 우리동네
class TownScreen extends StatefulWidget {
  const TownScreen({super.key});

  @override
  State<TownScreen> createState() => TownScreenState();
}

class TownScreenState extends State<TownScreen> {
  late SharedPreferences prefs;
  List<String> storedTowns = [];

/*
  @override
  void initState() {
    super.initState();
    initPrefs();
  }
  

  /// SharedPreferences 초기화
  void initPrefs() async {
    log('START initPrefs');
    prefs = await SharedPreferences.getInstance();
    final storedTownsInstance = prefs.getStringList(env.localStorageKey);

    log('storedTownsInstance : $storedTownsInstance');

    if (storedTownsInstance != null) {
      log('storedTownsInstance : $storedTownsInstance');
      setState(() {
        storedTowns = storedTownsInstance;
      });
    } else {
      storedTowns = [];
      await prefs.setStringList(env.localStorageKey, []);
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    log('TownScreen build');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectTownModel>(
            create: (_) => SelectTownModel())
      ],
      child: Consumer2<SelectTownModel, StoredTownModel>(
        builder: (context, selectTownModel, storedTownModel, child) =>
            TownWidget(
          // storedTowns: storedTowns,
          selectTownModel: selectTownModel,
          storedTownModel: storedTownModel,
        ),
      ),
      /*
        child: Column(
          children: [
            TownList(
          storedTowns: storedTowns,
          selectTownModel: selectTownModel,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: selectTownModel.townModel == null
                ? const Text('지역을 선택하세요')
                : WeatherListWidget(
                    selectTownModel: selectTownModel,
                  ),
          ),
        ),
          ],
        ),
      ),
      */
    );
  }
}

class TownWidget extends StatefulWidget {
  const TownWidget({
    super.key,
    // required this.storedTowns,
    required this.storedTownModel,
    required this.selectTownModel,
  });

  // final List<String> storedTowns;
  final SelectTownModel selectTownModel;
  final StoredTownModel storedTownModel;

  @override
  State<TownWidget> createState() => _TownWidgetState();
}

class _TownWidgetState extends State<TownWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Future<List<TownModel>> level1List;
  late Future<List<TownModel>> towns;

  /// 최초 호출시 저장
  Map<String, List<WeatherModel>> storedWeatherMap = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    log('START TownList initState');
    level1List = TownService.getTownList(1, null);
    // towns = TownService.getTownDetailList(widget.storedTowns);
    towns = TownService.getTownDetailList(
        widget.storedTownModel.towns.map((e) => e.code).toList());
  }

  /// 추가버튼 클릭
  void onClickedAddBtn() {
    // final townScreenState = context.findAncestorStateOfType<TownScreenState>()!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AddTownModalScreen(
            level1List: level1List,
            // alertDialog에서 사용하기 위한 townScreen의 state
            // townScreenState: townScreenState,
            storedTownModel: widget.storedTownModel,
          );
        });
  }

  /// 저장한 지역 삭제
  void deleteStoredTown(TownModel town) {
    // final townScreenState = context.findAncestorStateOfType<TownScreenState>()!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('우리동네를 삭제할까요?'),
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          content: Text(town.townName),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('cancel')),
            TextButton(
                onPressed: () async {
                  // final nextIdx = widget.storedTowns.indexOf(town.code);
                  /*
                  townScreenState.setState(() {
                    widget.storedTowns.remove(town.code);
                    // TODO - selectTownModel 업데이트
                    // final initTownModel = widget.storedTowns.length < nextIdx - 1 ? widget.storedTowns.last : widget.storedTowns[nextIdx];
                    // widget.selectTownModel.updateSelectTownCode(initTownModel);
                  });
                  */

                  widget.storedTownModel.deleteTownModel(town);

                  Navigator.pop(context);
                  // await townScreenState.prefs.setStringList(env.localStorageKey, widget.storedTowns);
                },
                child: const Text('DELETE')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final buttonColorScheme = Theme.of(context).buttonTheme.colorScheme!;
    return FutureBuilder(
      // future: TownService.getTownDetailList(widget.storedTowns),
      future: TownService.getTownDetailList(
          widget.storedTownModel.towns.map((e) => e.code).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          final list = snapshot.data!;
          final tabController = TabController(
            length: list.length,
            vsync: this,
            // initialIndex: widget.selectTownModel.townModel != null
            //     ? list.indexWhere((element) =>
            //         element.code == widget.selectTownModel.townModel!.code)
            //     : 0,
            // animationDuration: Duration.zero,
          );

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: buttonColorScheme.onSurface.withOpacity(.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TabBar(
                        controller: tabController,
                        padding: const EdgeInsets.all(5),
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: buttonColorScheme.onPrimary,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: buttonColorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        overlayColor: MaterialStatePropertyAll(
                            buttonColorScheme.primary.withOpacity(.2)),
                        splashBorderRadius: BorderRadius.circular(30),
                        dividerColor: Colors.transparent,
                        tabs: [
                          for (final t in list)
                            GestureDetector(
                              child: Tab(
                                text: t.townName,
                                height: 30,
                              ),
                              onLongPress: () {
                                log('long press ${t.code}!');
                                deleteStoredTown(t);
                              },
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: onClickedAddBtn,
                      child: const Text('ADD'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final t in list)
                      storedWeatherMap.containsKey(t.code)
                          ? WeatherWidget(list: storedWeatherMap[t.code]!)
                          : FutureBuilder(
                              future: WeatherService.getWeatherList(t),
                              builder: (context, snapshot) {
                                log('TownWidget FutureBuilder');
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasData) {
                                  final weatherList = snapshot.data!;
                                  storedWeatherMap[t.code] = weatherList;
                                  return WeatherWidget(list: weatherList);
                                }
                                return Container();
                              },
                            ),
                  ],
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
