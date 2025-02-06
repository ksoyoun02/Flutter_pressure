import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pressure_flutter/model/pressure_model.dart';
import 'package:pressure_flutter/service/pressure_service.dart';
import 'package:pressure_flutter/service/setting_service.dart';

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
      body: _pressureList.isEmpty
          ? Center(
              child: Text(
                "데이터가 없습니다",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : SingleChildScrollView(
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
                                  color: colors[pressure.pressureStatus] ??
                                      Colors.grey,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${pressure.systolic}"),
                                    Container(
                                      width: 30, // 밑줄 길이 조정
                                      height: 1.0, // 밑줄 두께
                                      color: Colors.black, // 밑줄 색상
                                      margin: EdgeInsets.symmetric(
                                          vertical: 1), // 위아래 여백
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDrawer(context),
        child: Icon(Icons.settings),
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 높이를 컨트롤 할 수 있도록 설정
      backgroundColor: Colors.transparent, // 배경을 투명하게 설정
      builder: (context) {
        return Container(
          color: Colors.white,
          height: 300, // 원하는 높이로 설정
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '설정',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('데이터 초기화'),
                  onTap: () {
                    // 확인 창을 띄운다
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("데이터 초기화"),
                          content: Text("정말 데이터를 초기화하시겠습니까?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 다이얼로그 닫기
                              },
                              child: Text("취소"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 다이얼로그 닫기
                                pressureService.deleteFile(); // 데이터 초기화 호출
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "데이터 초기화가 완료되었습니다.",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context, true); // Drawer 닫기
                              },
                              child: Text("확인"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value == true) {
        _loadPressureData();
      }
    });
  }
}
