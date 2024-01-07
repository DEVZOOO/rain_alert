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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget page = const Placeholder();  // TODO - error 처리
    switch (_selectedIndex) {
      case 0:
        page = LocationPage();
        break;
      case 1:
        page = TownPage();
        break;
      case 2:
        page = Placeholder();
        break;
    }

    return LayoutBuilder(
      builder: (context, containers) {
        return Scaffold(
          backgroundColor: theme.colorScheme.tertiaryContainer,
          body: SafeArea(child: page),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
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
