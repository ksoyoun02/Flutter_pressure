import 'package:flutter/material.dart';
import 'package:pressure_flutter/screens/pressure/pressure_bar.dart';
import 'package:pressure_flutter/screens/pressure/pressure_range.dart';
import 'package:pressure_flutter/screens/pressure/pressure_save.dart';
import 'picker_row.dart';

class PressureMain extends StatefulWidget {
  const PressureMain({super.key});

  @override
  State<PressureMain> createState() => _PressureMainState();
}

class _PressureMainState extends State<PressureMain> {
  int _currentSystolic = 120;
  int _currentDiastolic = 80;
  int _currentPulse = 70;
  int _pressureStatus = 0;

  final List<int> systolicRange = List.generate(111, (index) => 90 + index);
  final List<int> diastolicRange = List.generate(61, (index) => 60 + index);
  final List<int> pulseRange = List.generate(111, (index) => 40 + index);

  @override
  void initState() {
    super.initState();

    /**
     * Duration.zero는 즉시 실행되지만, 현재 프레임의 build() 함수가 끝난 후 실행됨.
     * 즉, initState()가 실행되는 동안 setState()를 직접 호출하지 않도록 방지하는 역할.
     */
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          _pressureStatus = _calculateInitialStatus();
        });
      }
    });
  }

  int _calculateInitialStatus() {
    if (_currentSystolic <= 90 || _currentDiastolic <= 60) {
      return 0;
    } else if (_currentSystolic < 120 && _currentDiastolic < 80) {
      return 1;
    } else if ((_currentSystolic >= 120 && _currentSystolic <= 129) &&
        _currentDiastolic < 80) {
      return 2;
    } else if ((_currentSystolic >= 130 && _currentSystolic <= 139) ||
        (_currentDiastolic >= 80 && _currentDiastolic <= 89)) {
      return 3;
    } else if ((_currentSystolic >= 140 && _currentSystolic <= 159) ||
        (_currentDiastolic >= 90 && _currentDiastolic <= 99)) {
      return 4;
    } else if (_currentSystolic >= 160 || _currentDiastolic >= 100) {
      return 5;
    } else {
      return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 25, left: 30, right: 30),
            child: MovingBarWidget(
              sp: _currentSystolic,
              dp: _currentDiastolic,
              onValueChanged: (statusInt) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _pressureStatus = statusInt;
                    });
                  }
                });
              },
            ),
          ),
          Column(
            children: [
              Divider(
                // 공간 분리용 밑줄
                color: const Color.fromARGB(255, 163, 163, 163), // 색상
                thickness: 1, // 두께
                indent: 20, // 왼쪽 여백
                endIndent: 20, // 오른쪽 여백
              ),
            ],
          ),
          Container(
            height: 147,
            margin: const EdgeInsets.only(left: 18, right: 18),
            child: Column(children: [
              PickerRow(
                label: "수축기 혈압",
                value: _currentSystolic,
                values: systolicRange,
                onSelected: (value) {
                  setState(() {
                    _currentSystolic = value.toInt();
                  });
                },
              ),
              PickerRow(
                label: "이완기 혈압",
                value: _currentDiastolic,
                values: diastolicRange,
                onSelected: (value) {
                  setState(() {
                    _currentDiastolic = value.toInt();
                  });
                },
              ),
              PickerRow(
                label: "맥박",
                value: _currentPulse,
                values: pulseRange,
                onSelected: (value) {
                  setState(() {
                    _currentPulse = value.toInt();
                  });
                },
              ),
            ]),
          ),
          Column(
            children: [
              Divider(
                // 공간 분리용 밑줄
                color: const Color.fromARGB(255, 163, 163, 163), // 색상
                thickness: 1, // 두께
                indent: 20, // 왼쪽 여백
                endIndent: 20, // 오른쪽 여백
              ),
            ],
          ),
          Container(
            height: 147,
            margin:
                const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
            child: PressureSave(
                currentSystolic: _currentSystolic,
                currentDiastolic: _currentDiastolic,
                currentPulse: _currentPulse,
                pressureStatus: _pressureStatus),
          ),
          Column(
            children: [
              Divider(
                // 공간 분리용 밑줄
                color: const Color.fromARGB(255, 163, 163, 163), // 색상
                thickness: 1, // 두께
                indent: 20, // 왼쪽 여백
                endIndent: 20, // 오른쪽 여백
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 275,
              margin: EdgeInsets.only(
                top: 5,
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: PressureRange(statusIndex: _pressureStatus),
            ),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
