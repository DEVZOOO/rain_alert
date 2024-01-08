import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/models/import.dart';
import '/src/screens/import.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rain Alert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => StorageTownProvider(),
        child: const MyHomePage(title: '레인알럿 - 비알리미'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0; // 네비게이션 인덱스

  // 페이지들
  final List<Widget> _pages = [LocationPage(), TownPage(), InfoPage()];
  final pageController = PageController();

  // 페이지변경
  void pageChangeHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, containers) {
        return Scaffold(
          backgroundColor: theme.colorScheme.tertiaryContainer,
          body: SafeArea(
            child: PageView(  // 위젯 상태값 유지 위함
              controller: pageController,
              onPageChanged: pageChangeHandler,
              physics: const NeverScrollableScrollPhysics(),  // 스와이프하면 페이지 바뀌는거 방지
              children: _pages,
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              pageController.jumpToPage(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Badge(
                  child: Icon(Icons.location_history)
                ),
                label: '내위치'
              ),
              NavigationDestination(icon: Icon(Icons.location_on), label: '우리동네'),
              NavigationDestination(icon: Icon(Icons.info_outline), label: '버전정보'),
            ],
          ),
        );
      },
    );
  }

}
