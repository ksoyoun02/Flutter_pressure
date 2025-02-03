import 'package:flutter/material.dart';

class PressureSave extends StatefulWidget {
  const PressureSave({super.key});

  @override
  State<PressureSave> createState() => _PressureSaveState();
}

class _PressureSaveState extends State<PressureSave> {
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  TimeOfDay getKoreanTime() {
    // 현재 시간 (UTC 기준)
    DateTime now = DateTime.now().toUtc();

    // 한국 표준시 (KST, UTC+9)로 변환
    DateTime koreanTime = now.add(Duration(hours: 9));

    // TimeOfDay 객체로 변환하여 반환
    return TimeOfDay.fromDateTime(koreanTime);
  }

  // 캘린더 다이얼로그 표시 함수
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // 시간 선택 다이얼로그 표시 함수
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedTime = getKoreanTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50, // 높이 100px
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 160, 136), // 배경색
              borderRadius: BorderRadius.circular(20), // 둥근 모서리
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "데이터 저장하기", // 표시할 텍스트
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 글자 색상
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_month),
                      iconSize: 40,
                      onPressed: _pickDate,
                    ),
                    Text(
                      _selectedDate == null
                          ? "날짜 선택"
                          : _selectedDate != null &&
                                  _selectedDate!.year == DateTime.now().year &&
                                  _selectedDate!.month ==
                                      DateTime.now().month &&
                                  _selectedDate!.day == DateTime.now().day
                              ? "오늘"
                              : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.access_time,
                        color: const Color.fromARGB(255, 59, 59, 59),
                      ),
                      iconSize: 40,
                      onPressed: _pickTime, // 클릭 시 시간 선택 창 띄우기
                    ),
                    Text(
                      _selectedTime == null
                          ? "시간 선택"
                          : "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
