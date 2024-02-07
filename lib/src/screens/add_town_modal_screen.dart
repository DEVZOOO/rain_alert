import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rain_alert/src/config/env.dart';
import 'package:rain_alert/src/models/stored_town_model.dart';
import 'package:rain_alert/src/models/town_model.dart';
import 'package:rain_alert/src/screens/town_screen.dart';
import 'package:rain_alert/src/services/town_service.dart';
import 'package:rain_alert/src/widgets/town_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTownModalScreen extends StatefulWidget {
  /// 최상위 지역리스트
  Future<List<TownModel>> level1List;
  // TownScreenState townScreenState;
  StoredTownModel storedTownModel;

  AddTownModalScreen({
    super.key,
    required this.level1List,
    // required this.townScreenState,
    required this.storedTownModel,
  });

  @override
  State<AddTownModalScreen> createState() => _AddTownModalScreenState();
}

class _AddTownModalScreenState extends State<AddTownModalScreen> {
  /// 선택한 지역코드
  String? selectedCode;

  String? level1Code;
  String? level2Code;
  String? level3Code;

  void onCloseModal() {
    /*
    setState(() {
      selectedCode = null;
      level1Code = null;
      level2Code = null;
      level3Code = null;
    });
   

    final parentTownListState =
        context.findAncestorStateOfType<TownListState>()!;
    parentTownListState.setState(() {
      parentTownListState.selectedCode = null;
    });
     */

    Navigator.pop(context);
  }

  void saveTown() async {
    log('saveTown');
    // final parentTownScreenState = widget.townScreenState;

    log('selectedCode : $selectedCode');

    if (selectedCode != null) {
      log('update ${env.localStorageKey}!');
      /*
      parentTownScreenState.setState(() {
        parentTownScreenState.storedTowns.add(selectedCode!);
      });

      // 시점때문에 가장 마지막에..
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          env.localStorageKey, parentTownScreenState.storedTowns);
      */

      widget.storedTownModel.addTownCode(selectedCode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("우리동네 추가"),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // level 1
          FutureBuilder(
            future: widget.level1List,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TownModel> result = snapshot.data!;

                return DropdownButtonFormField<String>(
                  value: level1Code,
                  items: [
                    for (final i in result)
                      DropdownMenuItem(
                        value: i.code,
                        child: Text(i.townName),
                      ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedCode = val;
                      level1Code = val;
                      level2Code = null;
                      level3Code = null;
                    });
                  },
                );
              } else {
                return const Text('에러가 발생하였습니다.');
              }
            },
          ),
          // level2
          FutureBuilder(
            future: TownService.getTownList(2, level1Code),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TownModel> result = snapshot.data!;

                return DropdownButtonFormField<String>(
                  value: level2Code,
                  items: [
                    for (final i in result)
                      DropdownMenuItem(
                        value: i.code,
                        child: Text(i.townName),
                      ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedCode = val;
                      level2Code = val;
                      level3Code = null;
                    });
                  },
                );
              } else {
                return const Text('에러가 발생하였습니다.');
              }
            },
          ),
          // level3
          FutureBuilder(
            future: TownService.getTownList(3, level2Code),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TownModel> result = snapshot.data!;

                return DropdownButtonFormField<String>(
                  value: level3Code,
                  items: [
                    for (final i in result)
                      DropdownMenuItem(
                        value: i.code,
                        child: Text(i.level3),
                      ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedCode = val;
                      level3Code = val;
                    });
                  },
                );
              } else {
                return const Text('에러가 발생하였습니다.');
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => onCloseModal(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            // Save
            saveTown();
            onCloseModal();
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
