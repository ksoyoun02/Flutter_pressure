import 'package:flutter/material.dart';
import 'package:pressure_flutter/screens/pressure/pressure_dropdown.dart';

class PressureSave extends StatefulWidget {
  const PressureSave({super.key});

  @override
  State<PressureSave> createState() => _PressureSaveState();
}

class _PressureSaveState extends State<PressureSave> {
  double _currentSystolic = 120; // 수축기 혈압
  double _currentDiastolic = 80; // 이완기 혈압
  double _currentPulse = 70; // 맥박

  final List<int> systolicRange =
      List.generate(111, (index) => 90 + index); // 90~200
  final List<int> diastolicRange =
      List.generate(61, (index) => 60 + index); // 60~120
  final List<int> pulseRange =
      List.generate(111, (index) => 40 + index); // 40~150

  void _showComboBoxModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text("항목 선택"),
          content: Padding(
            padding: const EdgeInsets.only(right: 17.0, left: 17.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("수축기 혈압", style: TextStyle(fontSize: 18)),
                    PressureDropdown(
                      value: _currentSystolic.toInt(),
                      items: systolicRange,
                      onChanged: (int? newValue) {
                        setState(
                          () {
                            _currentSystolic = newValue!.toDouble();
                          },
                        );
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("이완기 혈압", style: TextStyle(fontSize: 18)),
                    PressureDropdown(
                      value: _currentDiastolic.toInt(),
                      items: diastolicRange,
                      onChanged: (int? newValue) {
                        setState(
                          () {
                            _currentDiastolic = newValue!.toDouble();
                          },
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("맥박", style: TextStyle(fontSize: 18)),
                    PressureDropdown(
                      value: _currentPulse.toInt(),
                      items: pulseRange,
                      onChanged: (int? newValue) {
                        setState(
                          () {
                            _currentPulse = newValue!.toDouble();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentSystolic.toStringAsFixed(0), // 소수점 한 자리까지 출력
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    _currentDiastolic.toStringAsFixed(0), // 소수점 한 자리까지 출력
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    _currentPulse.toStringAsFixed(0), // 소수점 한 자리까지 출력
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: _showComboBoxModal,
                    child: const Text('모달 열기 (3개 숫자 콤보박스)'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
