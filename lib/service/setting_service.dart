import 'dart:io';
import 'package:excel/excel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pressure_flutter/service/pressure_service.dart';
import 'package:share_plus/share_plus.dart';
import '../model/pressure_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService {
  final PressureService pressureService = PressureService();

  Future<void> sendEmail() async {
    String username = 'devsoyeon02@gmail.com';
    String password = 'kupp cslb tfad ydje';

    final smtpServer = gmail(username, password);

    await createExcelFile();

    // 첨부할 파일 경로 설정
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/pressureExcel.xlsx';

    final message = Message()
      ..from = Address(username, 'Your Name') // 보내는 사람 이름 설정 가능
      ..recipients.add('sy@wepl.io') // 받는 사람 이메일
      ..subject = 'Flutter에서 보낸 이메일'
      ..text = '이것은 Flutter에서 보내는 테스트 이메일입니다.'
      ..html = '<h1>Flutter 이메일 전송</h1><p>SMTP를 사용한 이메일입니다.</p>'
      ..attachments.add(FileAttachment(File(filePath))); // 파일 첨부

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Email sending failed: $e');
    }
  }

  Future<void> createExcelFile() async {
    const Map<int, String> statusText = {
      0: "저혈압",
      1: "정상 혈압",
      2: "주의 혈압",
      3: "고혈압 전단계",
      4: "고혈압 1기",
      5: "고혈압 2기",
    };

    // 1. 엑셀 생성
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    final List<PressureModel> PressureList =
        await pressureService.loadPressureModel();

    // 2. 데이터 추가
    sheetObject
        .appendRow(['순번', '혈압상태', '수축기혈압', '이완기혈압', '맥박', '측정날짜', '저장날짜']);
    for (var pressureObj in PressureList) {
      sheetObject.appendRow([
        pressureObj.seq,
        statusText[pressureObj.pressureStatus],
        pressureObj.systolic,
        pressureObj.diastolic,
        pressureObj.pulse,
        pressureObj.date,
        pressureObj.saveDate
      ]);
    }

    // 3. 파일 저장
    var bytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/pressureExcel.xlsx';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);

    print('엑셀 파일 생성 완료: $filePath');
  }

  void shareFile() async {
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/pressureExcel.xlsx'; // 공유할 파일 경로
    await Share.shareXFiles([XFile(filePath)], text: '이 파일을 공유합니다.');
  }

  Future<void> saveUserInfo(String name, String email, String phone,
      String birth, String addr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_birth', birth);
    await prefs.setString('user_addr', addr);
  }

  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('user_name');
    String? email = prefs.getString('user_email');
    String? phone = prefs.getString('user_phone');
    String? birth = prefs.getString('user_birth');
    String? addr = prefs.getString('user_addr');

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birth': birth,
      'addr': addr,
    };
  }

  Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('user_birth');
    await prefs.remove('user_addr');
  }
}
