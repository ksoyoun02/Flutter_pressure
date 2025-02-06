class PressureModel {
  int? seq; // null 허용
  int systolic;
  int diastolic;
  int pulse;
  int pressureStatus;
  String date;
  String? saveDate;

  // 생성자
  PressureModel({
    this.seq,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.pressureStatus,
    required this.date,
    this.saveDate,
  });

  //fromJson 팩토리 생성자
  //JSON 데이터를 PressureModel 객체로 변환하는 팩토리 생성자
  //API 호출 후 JSON 형식으로 받아온 데이터를 PressureModel 객체로 쉽게 변환할 때 사용
  factory PressureModel.fromJson(Map<String, dynamic> json) {
    return PressureModel(
      seq: json['seq'],
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      pulse: json['pulse'],
      pressureStatus: json['pressureStatus'],
      date: json['date'],
      saveDate: json['saveDate'],
    );
  }

  //PressureModel 객체를 JSON 형식으로 변환합니다.
  //서버로 데이터를 전송하거나 로컬 저장 시 유용합니다.
  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'pressureStatus': pressureStatus,
      'date': date,
      'saveDate': saveDate,
    };
  }
}
