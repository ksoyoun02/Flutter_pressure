import 'package:flutter/material.dart';

class PressureDropdown extends StatelessWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int?> onChanged;

  const PressureDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<int>>((int item) {
        return DropdownMenuItem<int>(
          value: item,
          child: Text(
            item.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
      style: const TextStyle(fontSize: 16, color: Colors.black),
      dropdownColor: Colors.white,
      underline: Container(),
      borderRadius: BorderRadius.circular(12),
      icon:
          const Icon(Icons.arrow_drop_down, color: Colors.blueAccent, size: 30),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      isExpanded: false,
      menuMaxHeight: 300,
    );
  }
}
