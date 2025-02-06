class PressureModel {
  int? seq; // null 허용
  int systolic;
  int diastolic;
  int pulse;
  int pressureStatus;
  String date;
  String? saveDate;

  PressureModel({
    this.seq,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.pressureStatus,
    required this.date,
    this.saveDate,
  });

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
