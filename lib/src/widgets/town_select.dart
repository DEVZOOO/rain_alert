import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/models/import.dart';
import '/src/providers/import.dart' show StorageTownProvider;
import '/src/services/town_service.dart';

/// 지역 선택 박스
class TownSelect extends StatefulWidget {
  const TownSelect({super.key, required townListDept1}) 
    : _townListDept1 = townListDept1;

  final List<TownModel> _townListDept1;

  @override
  State<TownSelect> createState() => _TownSelectState();
}

class _TownSelectState extends State<TownSelect> {
  final TownService townService = TownService();
  

  // List<TownModel> _townListDept2 = [];
  // List<TownModel> _townListDept3 = [];

  /// dept1 code
  /*
  TownModel? _town1Code; // 앞의 두자리 - 뒤에 0 삭제하고 code like '{num}%'
  TownModel? _town2Code; // 앞의 네자리
  TownModel? _town3Code;
  */

  String? _town1Code; // 앞의 두자리 - 뒤에 0 삭제하고 code like '{num}%'
  String? _town2Code; // 앞의 네자리
  String? _town3Code;

  /// 선택한 지역 정보
  late TownModel _townInfo;

  @override
  Widget build(BuildContext context) {

    final storageTownProvider = context.watch<StorageTownProvider>();

    // final TextEditingController level3Controller = TextEditingController();

    // TODO - DB검색
    /*
    // 1dept 변경시 초기화되므로 재검색
    if (_town2Code == null) {
      townService.getTownList(2, _town1Code);
    }
    if (_town3Code == null) {
      townService.getTownList(3, _town2Code).then((value) => _townListDept3 = value);
    }
    */

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              DropdownButton<String>(
                itemHeight: 50,
                value: _town1Code,
                // TODO - 이미 있는거 보여주지 않기
                items: widget._townListDept1.map((e) => DropdownMenuItem(value: e.code, child: Text(e.level1),)).toList(),
                hint: const Text('선택하세요'),
                isExpanded: true,
                /*
                onChanged: (TownModel? townInfo) {
                  setState(() {
                    _town1Code = townInfo;
                    _town2Code = null;
                    _townInfo = townInfo!;
                  });
                },
                */
                onChanged: (String? code) {
                  setState(() {
                    _town1Code = code;
                    _town2Code = null;
                    _townInfo = widget._townListDept1.firstWhere((v) => v.code == code);
                  });
                },
              ),

              const SizedBox(height: 15),
          
              // level 2
              FutureBuilder(
                future: townService.getTownList(2, _town1Code),
                builder: (context, snapshot) {
                  late Widget result;
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<TownModel> list = snapshot.data!;

                    result = DropdownButton<String>(
                      value: _town2Code,
                      itemHeight: 50,
                      // TODO - 이미 있는거 보여주지 않기
                      items: list.map((e) => DropdownMenuItem(value: e.code, child: Text(e.level2 ?? ''),)).toList(),
                      hint: const Text('선택하세요'),
                      isExpanded: true,
                      /*
                      onChanged: (TownModel? townInfo) {
                        setState(() {
                          _town2Code = townInfo;
                          _townInfo = townInfo!;
                        });
                      },
                      */
                      onChanged: (String? code) {
                        setState(() {
                          _town2Code = code;
                          _townInfo = list.firstWhere((element) => element.code == code);
                        });
                      },
                    );
                  } else {
                    result = DropdownButton(
                      itemHeight: 50,
                      isExpanded: true,
                      hint: const Text(''),
                      onChanged: (_){},
                      items: [],
                    );
                  }
          
                  return result;
                },
              ),

              const SizedBox(height: 15),
              
              // level 3
              FutureBuilder(
                future: townService.getTownList(3, _town2Code),
                builder: (context, snapshot) {
                  late Widget result;
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<TownModel> list = snapshot.data!;
                    /*
                    result = DropdownMenu<TownModel>(
                      controller: level3Controller,
                      // TODO - 이미 있는거 보여주지 않기
                      dropdownMenuEntries: list.map((e) => DropdownMenuEntry(value: e, label: e.level3 ?? '')).toList(),
                      onSelected: (TownModel? townInfo) {
                        setState(() {
                          _townInfo = townInfo!;
                        });
                      },
                    );
                    */

                    result = DropdownButton<String>(
                      value: _town3Code,
                      itemHeight: 50,
                      // TODO - 이미 있는거 보여주지 않기
                      items: list.map((e) => DropdownMenuItem(value: e.code, child: Text(e.level3 ?? ''),)).toList(),
                      hint: const Text('선택하세요'),
                      isExpanded: true,
                      /*
                      onChanged: (TownModel? townInfo) {
                        setState(() {
                          _town3Code = townInfo;
                          _townInfo = townInfo!;
                        });
                      },
                      */
                      onChanged: (String? code) {
                        setState(() {
                          _town3Code = code;
                          _townInfo = list.firstWhere((element) => element.code == code);
                        });
                      },
                    );
          
                  } else {
                    result = DropdownButton(
                      itemHeight: 50,
                      hint: const Text(''),
                      isExpanded: true,
                      onChanged: (_){},
                      items: [],
                    );
                  }
          
                  return result;
                },
              ),
            ],
          ),
        ),

        // button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 취소버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),

            const SizedBox(width: 20),

            // 선택버튼
            TextButton(
              onPressed: () {
                // ignore: avoid_print
                print(_townInfo.code);
                // TODO - 저장
                storageTownProvider.insertTown(_townInfo);

                Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),

          ],
        ),
      ],
    );
  }
}