import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../model/pressure_model.dart';
import 'package:http/http.dart' as http;

class PressureService {
  final String apiUrl = 'http://10.0.2.2:8080/calendar'; // API URL

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/pressure_data.json');
  }

  Future<String> addPressureModel(PressureModel newModel) async {
    try {
      final file = await _getFile();
      List<PressureModel> pressureModels = [];

      if (await file.exists()) {
        // 파일이 존재하면 기존 데이터 읽기
        final jsonString = await file.readAsString();

        // 기존 JSON 데이터를 리스트로 변환
        final formattedJsonString =
            jsonString.trim().replaceAll(RegExp(r'}\s*(?=\{)'), '},');
        List<dynamic> jsonData = jsonDecode(formattedJsonString);

        // 기존 데이터를 PressureModel로 변환하여 리스트에 저장
        pressureModels =
            jsonData.map((item) => PressureModel.fromJson(item)).toList();
      }

      // 기존 데이터의 마지막 seq 값 찾기
      int lastSeq =
          pressureModels.isNotEmpty ? (pressureModels.last.seq ?? 0) : 0;

      // 새로운 모델에 seq 값 추가 (기존 seq + 1)
      newModel.seq = lastSeq + 1;

      // saveDate를 현재 날짜 및 시간으로 설정
      DateTime nowDate = DateTime.now();
      TimeOfDay nowTime =
          TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 9)));
      newModel.saveDate = DateTime(
        nowDate.year,
        nowDate.month,
        nowDate.day,
        nowTime.hour,
        nowTime.minute,
      ).toString();

      // 새로운 모델을 리스트에 추가
      pressureModels.add(newModel);

      // 파일에 새로운 데이터 저장
      final newJsonString =
          jsonEncode(pressureModels.map((e) => e.toJson()).toList());
      await file.writeAsString(newJsonString);

      print("새 데이터가 성공적으로 저장되었습니다.");
      return "success";
    } catch (e) {
      print("파일 저장 오류: $e");
      return "fail";
    }
  }

  // 📌 혈압 데이터 불러오기
  Future<List<PressureModel>> loadPressureModel() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        var jsonString = await file.readAsString();

        // jsonString이 배열 형식이 아니면 수동으로 배열 형식으로 변환
        final formattedJsonString =
            jsonString.trim().replaceAll(RegExp(r'}\s*(?=\{)'), '},');

        // 파일 내용이 배열 형식인지 확인
        List<dynamic> jsonData = jsonDecode(formattedJsonString);

        // PressureModel 객체로 변환하여 반환
        return jsonData.map((item) => PressureModel.fromJson(item)).toList();
      }
    } catch (e) {
      print("파일 읽기 오류: $e");
    }
    return []; // 데이터가 없으면 빈 리스트 반환
  }

  // 📌 전체 데이터 삭제
  Future<void> clearAllData() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  // 파일 자체 삭제
  Future<void> deleteFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        await file.delete();
        print('파일이 삭제되었습니다.');
      } else {
        print('파일이 존재하지 않습니다.');
      }
    } catch (e) {
      print('파일 삭제 오류: $e');
    }
  }
}
