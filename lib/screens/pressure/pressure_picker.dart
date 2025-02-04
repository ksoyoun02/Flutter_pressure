import 'package:flutter/material.dart';

void showWheelPicker(
  BuildContext context,
  String label,
  int currentValue,
  List<int> values,
  ValueChanged<int> onSelected,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int selectedIndex = values.indexOf(currentValue.toInt());

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  controller:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40.0,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedIndex = index;
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
                            fontWeight: FontWeight.bold,
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                    childCount: values.length,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "완료",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ],
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      );
    },
  );
}
