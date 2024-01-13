
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'import.dart';
import '/src/models/import.dart';
import '/src/providers/import.dart';

/// 동네리스트
class TownList extends StatelessWidget {
  const TownList({super.key, required selectedTownCode, required clickHandler, required openModalHandler})
    : _selectedTownCode = selectedTownCode
    , _clickHandler = clickHandler
    , _openModalHandler = openModalHandler;

  final String _selectedTownCode;
  final Function(TownModel) _clickHandler;
  final Function() _openModalHandler;

  // TODO - 사용자가 저장한 위치
  // late List<TownModel> _townList;
  // late StorageTownProvider _townProvider;

  @override
  Widget build(BuildContext context) {
    // _townProvider = Provider.of<StorageTownProvider>(context);
    // _townList = _townProvider.townList;

    final theme = Theme.of(context);

    /*
    Widget widget;

    if ( _townList.isEmpty) {
      // TODO - modal
      // widget = TownSelect(allTownList);
      widget = Container();
    } else {
      widget = SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 수평
        child: Row(
          children: _townList.map((item) => TownName(
            [item.dept1, item.dept2, item.dept3].join(' '),
            item.code == _selectedTownCode,
            () => _clickHandler(item.code)
          )).toList(),
        ),
      );
    }
    */

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 저장한 지역정보 provider
          Consumer<StorageTownProvider>(
            builder: (context, townProvider, child) {
              List<TownModel> townList = townProvider.townList;
              if (townList.isEmpty) {
                return Container();
              } else {
                List<Widget> children = [];
                int len = townList.length;

                // make children list
                for (int i = 0; i < len; i += 1) {
                  TownModel item = townList[i];
                  // 처음 아니면 여백 추가
                  if (i > 0) {
                    children.add(const SizedBox(width: 10, height: 1,));
                  }

                  children.add(
                      TownName(
                          [item.level1, item.level2, item.level3].join(' '),
                          item.code == _selectedTownCode,
                          () => _clickHandler.call(item),
                      )
                  );

                } // END for

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 수평
                  child: Row(
                    /*
                    children: townList.map((item) => TownName(
                      [item.dept1, item.dept2, item.dept3].join(' '),
                      item.code == _selectedTownCode,
                      () => _clickHandler.call(item.code)
                    )).toList(),
                     */
                    children: children,
                  ),
                );
              }
            },
          ),

          // 여백
          const SizedBox(width: 10, height: 0),

          // 추가버튼
          TextButton(
            onPressed: _openModalHandler,
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}



