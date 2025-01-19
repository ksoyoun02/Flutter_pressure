import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PressureSave extends StatefulWidget {
  const PressureSave({super.key});

  @override
  State<PressureSave> createState() => _PressureSaveState();
}

class _PressureSaveState extends State<PressureSave> {
  double _currentSystolic = 120; // 초기 수축기 혈압 값
  double _currentDiastolic = 80; // 초기 이완기 혈압 값
  final _systolicController = TextEditingController(); // 수축기 혈압 입력
  final _diastolicController = TextEditingController(); // 이완기 혈압 입력

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. 가로 막대 바
          Expanded(
            flex: 1,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 25.0, right: 10.0, left: 10.0),
              child: Stack(
                children: [
                  // 막대 바 배경
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // 막대 바 안의 화살표
                  Positioned(
                    left: (_currentSystolic / 200) *
                        MediaQuery.of(context).size.width, // 화살표 위치 계산
                    top: -15,
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_drop_down,
                            color: Colors.red, size: 40),
                        Container(
                          width: 3,
                          height: 30,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 중간 부분 수정: 혈압 입력 필드를 하나의 휠 선택기로 변경
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '혈압 입력',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 250,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    '혈압 선택',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      // 수축기 혈압 선택 휠
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 32.0,
                                          onSelectedItemChanged: (int value) {
                                            setState(() {
                                              _currentSystolic =
                                                  80 + value.toDouble();
                                            });
                                          },
                                          children: List<Widget>.generate(121,
                                              (int index) {
                                            return Center(
                                                child: Text('${80 + index}'));
                                          }),
                                        ),
                                      ),
                                      // 이완기 혈압 선택 휠
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 32.0,
                                          onSelectedItemChanged: (int value) {
                                            setState(() {
                                              _currentDiastolic =
                                                  50 + value.toDouble();
                                            });
                                          },
                                          children: List<Widget>.generate(91,
                                              (int index) {
                                            return Center(
                                                child: Text('${50 + index}'));
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // 하단 선택 창 닫기
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                        '수축기: $_currentSystolic mmHg, 이완기: $_currentDiastolic mmHg'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // 선택한 값 업데이트
                    },
                    child: const Text('혈압 저장'),
                  ),
                ],
              ),
            ),
          ),

          // 3. 기록 및 혈압 범위 표시
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '측정 기록',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        Text('수축기 혈압: $_currentSystolic mmHg'),
                        Text('이완기 혈압: $_currentDiastolic mmHg'),
                        const SizedBox(height: 8),
                        Text(
                          '혈압 범위: ${getBloodPressureCategory(_currentSystolic, _currentDiastolic)}',
                        ),
                        const SizedBox(height: 8),
                        const Text('정상: 수축기 120mmHg 미만, 이완기 80mmHg 미만\n'
                            '고혈압 전단계: 수축기 120~139mmHg, 이완기 80~89mmHg\n'
                            '경도 고혈압: 수축기 140~159mmHg, 이완기 90~99mmHg\n'
                            '중등도 이상 고혈압: 수축기 160mmHg 이상, 이완기 100mmHg 이상\n'
                            '저혈압: 수축기 100mmHg 미만, 이완기 60mmHg 미만'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getBloodPressureCategory(double systolic, double diastolic) {
    if (systolic < 100 && diastolic < 60) {
      return '저혈압';
    } else if (systolic < 120 && diastolic < 80) {
      return '정상';
    } else if ((systolic >= 120 && systolic < 140) ||
        (diastolic >= 80 && diastolic < 90)) {
      return '고혈압 전단계';
    } else if ((systolic >= 140 && systolic < 160) ||
        (diastolic >= 90 && diastolic < 100)) {
      return '경도 고혈압';
    } else if (systolic >= 160 || diastolic >= 100) {
      return '중등도 이상 고혈압';
    } else {
      return '범위 외';
    }
  }
}
