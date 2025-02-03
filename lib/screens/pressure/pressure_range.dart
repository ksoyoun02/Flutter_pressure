import 'package:flutter/material.dart';

class PressureRange extends StatelessWidget {
  final int statusIndex;

  const PressureRange({
    super.key,
    required this.statusIndex,
  });

  @override
  Widget build(BuildContext context) {
    const List<Color> colors = [
      Colors.blue,
      Color(0xFFB2DFDB), // 정상 혈압 (연한 초록)
      Color(0xFFFFF176), // 주의 혈압 (연한 노랑)
      Color(0xFFFFA726), // 고혈압 전단계 (연한 주황)
      Color(0xFFFFA3C2), // 고혈압 1기 (연한 핑크)
      Color(0xFFFF5E6E), // 고혈압 2기 (강한 핑크)
    ];

    const List<Map<String, dynamic>> pressureList = [
      {
        "seq": 0,
        "icon": Icons.circle,
        "label": "저혈압",
        "spRange": "90 이하",
        "dpRange": "60 이하",
        "temp": "그리고"
      },
      {
        "seq": 1,
        "icon": Icons.circle,
        "label": "정상 혈압",
        "spRange": "120 이하",
        "dpRange": "80 이하",
        "temp": "그리고"
      },
      {
        "seq": 2,
        "icon": Icons.circle,
        "label": "주의 혈압",
        "spRange": "120 ~ 129",
        "dpRange": "80 이하",
        "temp": "그리고"
      },
      {
        "seq": 3,
        "icon": Icons.circle,
        "label": "고혈압 전단계",
        "spRange": "130 ~ 139",
        "dpRange": "80 ~ 89",
        "temp": "또는"
      },
      {
        "seq": 4,
        "icon": Icons.circle,
        "label": "고혈압 1기",
        "spRange": "140 ~ 159",
        "dpRange": "90 ~ 99",
        "temp": "또는"
      },
      {
        "seq": 5,
        "icon": Icons.circle,
        "label": "고혈압 2기",
        "spRange": "160 이상",
        "dpRange": "100 이상",
        "temp": "또는"
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder(
            verticalInside: BorderSide(
              color: const Color.fromARGB(255, 177, 177, 177), // 세로줄 색상
              width: 0.5, // 세로줄 두께
            ),
            horizontalInside: BorderSide.none, // 세로줄만 활성화, 가로줄 비활성화
            top: BorderSide.none, // 헤더 상단 테두리 비활성화
            bottom: BorderSide.none, // 테이블 하단 테두리 비활성화
          ),
          columnWidths: {
            0: FlexColumnWidth(0.8), // 아이콘 칸 (작게)
            1: FlexColumnWidth(2), // 혈압 상태
            2: FlexColumnWidth(1.8), // 수축기 혈압
            3: FlexColumnWidth(1.5), // 중간 빈 칸
            4: FlexColumnWidth(1.8), // 이완기 혈압
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 228)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('혈압 상태',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('수축기혈압',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('이완기혈압',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            for (var index = 0;
                index < pressureList.length;
                index++) // 리스트의 각 항목에 대해 행 추가
              TableRow(
                decoration: BoxDecoration(
                  color: index == statusIndex
                      ? const Color.fromARGB(
                          255, 255, 203, 203) // index가 2일 때 배경색 변경
                      : Colors.transparent, // 나머지 행은 기본 배경색 유지
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      pressureList[index]['icon'],
                      color: colors[index],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      pressureList[index]['label'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${pressureList[index]['spRange']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${pressureList[index]['temp']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${pressureList[index]['dpRange']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
