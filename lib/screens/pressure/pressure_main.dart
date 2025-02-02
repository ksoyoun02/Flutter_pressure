import 'package:flutter/material.dart';
import 'package:pressure_flutter/screens/pressure/pressure_bar.dart';
import 'picker_row.dart';

class PressureSave extends StatefulWidget {
  const PressureSave({super.key});

  @override
  State<PressureSave> createState() => _PressureSaveState();
}

class _PressureSaveState extends State<PressureSave> {
  double _currentSystolic = 120;
  double _currentDiastolic = 80;
  double _currentPulse = 70;

  final List<int> systolicRange = List.generate(111, (index) => 90 + index);
  final List<int> diastolicRange = List.generate(61, (index) => 60 + index);
  final List<int> pulseRange = List.generate(111, (index) => 40 + index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 70,
            margin:
                const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: MovingBarWidget(sp: _currentSystolic, dp: _currentDiastolic),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(children: [
                PickerRow(
                  label: "수축기 혈압",
                  value: _currentSystolic,
                  values: systolicRange,
                  onSelected: (value) {
                    setState(() {
                      _currentSystolic = value.toDouble();
                    });
                  },
                ),
                PickerRow(
                  label: "이완기 혈압",
                  value: _currentDiastolic,
                  values: diastolicRange,
                  onSelected: (value) {
                    setState(() {
                      _currentDiastolic = value.toDouble();
                    });
                  },
                ),
                PickerRow(
                  label: "맥박",
                  value: _currentPulse,
                  values: pulseRange,
                  onSelected: (value) {
                    setState(() {
                      _currentPulse = value.toDouble();
                    });
                  },
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: PressureSave(),
            ),
          )
        ],
      ),
    );
  }
}
