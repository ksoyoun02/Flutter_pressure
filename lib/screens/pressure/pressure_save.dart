import 'package:flutter/material.dart';
import 'package:pressure_flutter/model/pressure_model.dart';
import 'package:pressure_flutter/service/pressure_service.dart';

class PressureSave extends StatefulWidget {
  final int currentSystolic;
  final int currentDiastolic;
  final int currentPulse;
  final int pressureStatus;

  const PressureSave({
    super.key,
    required this.currentSystolic,
    required this.currentDiastolic,
    required this.currentPulse,
    required this.pressureStatus,
  });

  @override
  State<PressureSave> createState() => _PressureSaveState();
}

class _PressureSaveState extends State<PressureSave> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.fromDateTime(
      DateTime.now().add(Duration(hours: 9))); // 한국 시간으로 초기화
  final pressureService = PressureService();

  // 한국 표준시로 시간을 가져오는 함수
  TimeOfDay getKoreanTime() {
    DateTime koreanTime = DateTime.now().add(Duration(hours: 9)); // 한국 표준시
    return TimeOfDay.fromDateTime(koreanTime);
  }

  // 캘린더 다이얼로그 표시 함수
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // 시간 선택 다이얼로그 표시 함수
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // 데이터 저장 및 처리
  void _savePressureData() async {
    PressureModel newRecode = PressureModel(
      seq: 0,
      systolic: widget.currentSystolic,
      diastolic: widget.currentDiastolic,
      pulse: widget.currentPulse,
      pressureStatus: widget.pressureStatus,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ).toString(), // DateTime 형식으로 저장
    );

    String result = await pressureService.addPressureModel(newRecode);

    // 결과에 따라 SnackBar 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result == "success" ? "저장이 완료되었습니다." : "저장에 실패했습니다.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black.withOpacity(0.7), // 불투명도 적용
        duration: Duration(seconds: 2), // 2초 후 자동으로 사라짐
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 데이터 저장 버튼
          InkWell(
            onTap: _savePressureData,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 160, 136),
                borderRadius: BorderRadius.circular(20),
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
                  "데이터 저장하기",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),

          // 날짜 및 시간 선택 영역
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
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
                      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.access_time),
                      iconSize: 40,
                      onPressed: _pickTime,
                    ),
                    Text(
                      "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
