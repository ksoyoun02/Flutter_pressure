class PressureModel {
  int seq;
  int systolic;
  int diastolic;
  int pulse;
  int pressureStatus;
  String date;

  PressureModel({
    required this.seq,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.pressureStatus,
    required this.date,
  });

  factory PressureModel.fromJson(Map<String, dynamic> json) {
    return PressureModel(
      seq: json['seq'] ?? 0, // seq 필드가 없을 경우 기본값 0
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      pulse: json['pulse'],
      pressureStatus: json['pressureStatus'],
      date: json['date'],
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
    };
  }
}
