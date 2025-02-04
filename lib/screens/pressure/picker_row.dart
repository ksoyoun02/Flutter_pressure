import 'package:flutter/material.dart';
import 'pressure_picker.dart';

class PickerRow extends StatelessWidget {
  final String label;
  final int value;
  final List<int> values;
  final ValueChanged<int> onSelected;

  const PickerRow({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          GestureDetector(
            onTap: () =>
                showWheelPicker(context, label, value, values, onSelected),
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toInt().toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
