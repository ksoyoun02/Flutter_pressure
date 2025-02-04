import 'package:flutter/material.dart';

class MovingBarWidget extends StatefulWidget {
  final int sp;
  final int dp;
  final int min;
  final int max;
  final int barWidth;
  final Function(int) onValueChanged;

  const MovingBarWidget({
    super.key,
    required this.sp,
    required this.dp,
    this.min = 50,
    this.max = 200,
    this.barWidth = 400,
    required this.onValueChanged,
  });

  @override
  State<MovingBarWidget> createState() => _MovingBarWidgetState();
}

class _MovingBarWidgetState extends State<MovingBarWidget> {
  String bloodPressureCategory = "정상 혈압";
  int pressureStatus = 2;

  static const List<Color> colors = [
    Colors.blue,
    Color(0xFFB2DFDB), // 정상 혈압 (연한 초록)
    Color(0xFFFFF176), // 주의 혈압 (연한 노랑)
    Color(0xFFFFA726), // 고혈압 전단계 (연한 주황)
    Color(0xFFFFA3C2), // 고혈압 1기 (연한 핑크)
    Color(0xFFFF5E6E), // 고혈압 2기 (강한 핑크)
  ];

  static const List<Map<String, dynamic>> pressureList = [
    {"seq": 1, "label": "저혈압"},
    {"seq": 2, "label": "정상 혈압"},
    {"seq": 3, "label": "주의 혈압"},
    {"seq": 4, "label": "고혈압 전단계"},
    {"seq": 5, "label": "고혈압 1기"},
    {"seq": 6, "label": "고혈압 2기"},
    {"seq": 0, "label": "알 수 없음"},
  ];

  @override
  void initState() {
    super.initState();
    _updateBloodPressureCategory(widget.sp, widget.dp);
  }

  @override
  void didUpdateWidget(covariant MovingBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sp != widget.sp || oldWidget.dp != widget.dp) {
      _updateBloodPressureCategory(widget.sp, widget.dp);
      widget.onValueChanged(pressureStatus);
    }
  }

  void _updateBloodPressureCategory(int sp, int dp) {
    int newStatus;
    String newCategory;

    if (sp <= 90 || dp <= 60) {
      newStatus = 0;
    } else if (sp < 120 && dp < 80) {
      newStatus = 1;
    } else if ((sp >= 120 && sp <= 129) && dp < 80) {
      newStatus = 2;
    } else if ((sp >= 130 && sp <= 139) || (dp >= 80 && dp <= 89)) {
      newStatus = 3;
    } else if ((sp >= 140 && sp <= 159) || (dp >= 90 && dp <= 99)) {
      newStatus = 4;
    } else if (sp >= 160 || dp >= 100) {
      newStatus = 5;
    } else {
      newStatus = 6;
    }

    newCategory = pressureList[newStatus]["label"];

    if (pressureStatus != newStatus) {
      setState(() {
        pressureStatus = newStatus;
        bloodPressureCategory = newCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // 색상 바
            Row(
              children: List.generate(colors.length, (index) {
                return Expanded(
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: index == 0
                          ? const BorderRadius.horizontal(
                              left: Radius.circular(10))
                          : index == colors.length - 1
                              ? const BorderRadius.horizontal(
                                  right: Radius.circular(10))
                              : null,
                    ),
                  ),
                );
              }),
            ),
            // 눈금 표시
            Positioned.fill(
              child: Row(
                children: List.generate(colors.length, (index) {
                  return Expanded(
                    child: index == pressureStatus
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: 2, height: 15, color: Colors.black),
                          )
                        : const SizedBox.shrink(),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          bloodPressureCategory,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    );
  }
}
