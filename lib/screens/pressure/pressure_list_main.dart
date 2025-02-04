import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pressure_flutter/model/pressure_model.dart';
import 'package:pressure_flutter/service/pressure_service.dart';

class PressureListMain extends StatefulWidget {
  const PressureListMain({super.key});

  @override
  State<PressureListMain> createState() => _PressureListMainState();
}

class _PressureListMainState extends State<PressureListMain> {
  final pressureService = PressureService();
  List<PressureModel> _pressureList = [];

  @override
  void initState() {
    super.initState();
    _loadPressureData();
  }

  Future<void> _loadPressureData() async {
    List<PressureModel> data = await pressureService.loadPressureModel();
    setState(() {
      _pressureList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Map<int, Color> colors = {
      0: Colors.blue,
      1: Color(0xFFB2DFDB),
      2: Color(0xFFFFF176),
      3: Color(0xFFFFA726),
      4: Color(0xFFFFA3C2),
      5: Color(0xFFFF5E6E),
    };

    const Map<int, String> statusText = {
      0: "저혈압",
      1: "정상 혈압",
      2: "주의 혈압",
      3: "고혈압 전단계",
      4: "고혈압 1기",
      5: "고혈압 2기",
    };

    String formatDate(String dateString) {
      DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(date);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: _pressureList
                .map(
                  (pressure) => Row(
                    children: [
                      // 왼쪽 20% 영역: 혈압 상태 아이콘
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                colors[pressure.pressureStatus] ?? Colors.grey,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${pressure.systolic}"),
                              Container(
                                width: 30, // 밑줄 길이 조정
                                height: 1.0, // 밑줄 두께
                                color: Colors.black, // 밑줄 색상
                                margin:
                                    EdgeInsets.symmetric(vertical: 1), // 위아래 여백
                              ),
                              Text("${pressure.diastolic}"),
                            ],
                          ),
                        ),
                      ),
                      // 오른쪽 80% 영역: 날짜, 시간, 혈압 수치, 맥박 정보
                      Expanded(
                        child: ListTile(
                          title: Text(
                            statusText[pressure.pressureStatus]!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "${formatDate(pressure.date)} / ${pressure.pulse} BPM"),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
