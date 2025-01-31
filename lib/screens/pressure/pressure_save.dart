import 'package:flutter/material.dart';

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
  void _showWheelPicker(BuildContext context, String label, double currentValue,
      List<int> values, ValueChanged<int> onSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedIndex = values.indexOf(currentValue.toInt());

        return StatefulBuilder(
          // StatefulBuilder 사용
          builder: (context, setState) {
            return AlertDialog(
              title: Text(label),
              content: SizedBox(
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  controller:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40.0,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedIndex = index; // 실시간으로 selectedIndex 업데이트
                    });
                    onSelected(values[index]);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          values[index].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold, // 글자 두께 설정
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.black, // 선택된 항목에 색상 다르게
                          ),
                        ),
                      );
                    },
                    childCount: values.length,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("완료",
                      style: TextStyle(fontSize: 18, color: Colors.blue)),
                ),
              ],
              backgroundColor: Colors.white, // 다이얼로그 배경 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // 다이얼로그 모서리 둥글게
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildPickerRow("수축기 혈압", _currentSystolic, systolicRange, (value) {
            setState(() {
              _currentSystolic = value.toDouble();
            });
          }),
          _buildPickerRow("이완기 혈압", _currentDiastolic, diastolicRange, (value) {
            setState(() {
              _currentDiastolic = value.toDouble();
            });
          }),
          _buildPickerRow("맥박", _currentPulse, pulseRange, (value) {
            setState(() {
              _currentPulse = value.toDouble();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildPickerRow(String label, double value, List<int> values,
      ValueChanged<int> onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          GestureDetector(
            onTap: () =>
                _showWheelPicker(context, label, value, values, onSelected),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(value.toInt().toString(),
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
