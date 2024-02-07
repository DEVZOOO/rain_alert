import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rain_alert/src/config/env.dart';
import 'package:rain_alert/src/models/select_town_model.dart';
import 'package:rain_alert/src/models/town_model.dart';
import 'package:rain_alert/src/screens/add_town_modal_screen.dart';
import 'package:rain_alert/src/screens/town_screen.dart';
import 'package:rain_alert/src/services/town_service.dart';

/// 지역리스트
class TownList extends StatefulWidget {
  const TownList({
    super.key,
    required this.storedTowns,
    required this.selectTownModel,
  });

  final List<String> storedTowns;
  final SelectTownModel selectTownModel;

  @override
  State<TownList> createState() => TownListState();
}

class TownListState extends State<TownList> {
  /// 저장된 지역 상세정보 리스트
  late Future<List<TownModel>> towns;

  /// 최상위 지역리스트
  late Future<List<TownModel>> level1List;

  @override
  void initState() {
    super.initState();
    log('START TownList initState');
    towns = TownService.getTownDetailList(widget.storedTowns);
    level1List = TownService.getTownList(1, null);
  }

  @override
  void didUpdateWidget(covariant TownList oldWidget) {
    super.didUpdateWidget(oldWidget);
    log('TownList didUpdateWidget');
    towns = TownService.getTownDetailList(widget.storedTowns);
  }

  /// 추가버튼 클릭
  void onClickedAddBtn() {
    // final townScreenState = context.findAncestorStateOfType<TownScreenState>()!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // AlertDialog는 stateless widget이므로 state 사용하려면 stateful widget으로 감싸야 함
          /*
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog();
            },
          );
          */
          /*
          return AddTownModalScreen(
            level1List: level1List,
            // alertDialog에서 사용하기 위한 townScreen의 state
            townScreenState: townScreenState,
          );
          */
          return const Placeholder();
        });
  }

  /// 저장한 지역 삭제
  void deleteStoredTown(TownModel town) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('cancel')),
            TextButton(
                onPressed: () async {
                  final townScreenState =
                      context.findAncestorStateOfType<TownScreenState>()!;
                  townScreenState.setState(() {
                    widget.storedTowns.remove(town.code);
                  });
                  await townScreenState.prefs
                      .setStringList(env.localStorageKey, widget.storedTowns);
                },
                child: const Text('DELETE')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('TownList build');
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
            future: towns,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('wait');
              }

              if (snapshot.hasData) {
                final towns = snapshot.data!;
                return towns.isNotEmpty
                    ? Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Stack(
                            alignment: Alignment
                                .centerRight, // TODO - 왼쪽정렬이어야 하는데 gradient때문에 임시..
                            children: [
                              ListView.separated(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                scrollDirection: Axis.horizontal,
                                itemCount: towns.length,
                                itemBuilder: (context, index) {
                                  TownModel town = towns[index];
                                  return town.code ==
                                          widget.selectTownModel.townModel?.code
                                      ? FilledButton(
                                          onPressed: () {},
                                          child: Text(town.townName),
                                        )
                                      : FilledButton.tonal(
                                          onPressed: () {
                                            // update selectTownModel
                                            widget.selectTownModel
                                                .updateSelectTownCode(town);
                                          },
                                          onLongPress: () {},
                                          child: Text(town.townName),
                                        );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 10,
                                  height: 1,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: 30,
                                  // height: 40, // TODO - 상위 height과 동일한 간격?
                                  alignment: Alignment.topRight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0),
                                        Colors.white,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              } else if (snapshot.hasError) {
                return const Text('on Error!');
              } else {
                return const Text('hasData hasError');
              }
            },
          ),
          OutlinedButton(
            onPressed: onClickedAddBtn,
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}
