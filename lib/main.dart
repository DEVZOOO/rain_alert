import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rain_alert/src/models/stored_town_model.dart';
import 'package:rain_alert/src/models/town_model.dart';
import 'package:rain_alert/src/screens/info_screen.dart';
import 'package:rain_alert/src/screens/town_screen.dart';
import 'package:weather_icons/weather_icons.dart';

Future main() async {
  await dotenv.load(fileName: 'env/.env');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StoredTownModel>(
          create: (context) => StoredTownModel(),
        )
      ],
      child: MaterialApp(
        // refresh when pull
        scrollBehavior: const MaterialScrollBehavior()
            .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _menuIndex = 0;

  final List<Widget> _pages = [
    const TownScreen(),
    const InfoScreen(),
  ];

  final pageController = PageController();

  // 페이지변경
  void pageChangeHandler(int index) {
    setState(() {
      _menuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            body: PageView(
              // 위젯 상태값 유지 위함
              controller: pageController,
              onPageChanged: pageChangeHandler,
              physics:
                  const NeverScrollableScrollPhysics(), // 스와이프하면 페이지 바뀌는거 방지
              children: _pages,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _menuIndex,
              onDestinationSelected: (value) =>
                  pageController.jumpToPage(value),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.location_on),
                  label: '우리동네',
                ),
                NavigationDestination(
                  icon: Icon(Icons.info_outline),
                  label: '버전정보',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

// tabcontroller 는 stateful widget에서 사용 가능
class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  int idx = 0;

  late int randomNum;

  @override
  void initState() {
    super.initState();
    randomNum = Random().nextInt(1000);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoredTownModel>(
      builder: (context, storedTownModel, child) {
        final tabController = TabController(
          length: storedTownModel.towns.length,
          vsync: this,
          initialIndex: idx,
        );
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    storedTownModel.addTownModel(TownModel.fromJson({
                      'code': Random().nextInt(10000000).toString(),
                      'level1': 'test',
                      'level': 1,
                      'x': 10,
                      'y': 10,
                    }));
                  },
                  child: const Text('ADD'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nowIdx = tabController.index; // 삭제할 아이템 인덱스
                    // 삭제하는 아이템이 마지막이면 마지막 인덱스 선택
                    // delete하면서 리랜더링되므로 setState 호출하지 않아도 됌?
                    final nextIdx = storedTownModel.towns.length - 1 == nowIdx
                        ? nowIdx - 1 // 삭제전 길이이므로 -2
                        : nowIdx;
                    idx = nextIdx;

                    storedTownModel.deleteTownModel(storedTownModel.towns.last);
                  },
                  child: const Text('DEL'),
                ),
              ],
            ),
            TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                for (final t in storedTownModel.towns)
                  Tab(
                    text: t.code,
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final t in storedTownModel.towns)
                    RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 3));
                        setState(() {});
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            child: Container(
                              color: Colors.amber,
                              child: Text('${t.code} tab! $randomNum'),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
*/