class AttendanceModel {
  final AttendanceSummary summary;
  final Map<String, dynamic> details;

  AttendanceModel({required this.summary, required this.details});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      summary: AttendanceSummary.fromJson(json['summary']),
      details: json['details'] ?? {},
    );
  }
}

class AttendanceSummary {
  final int presentDays;
  final int lateDays;
  final int absentDays;

  AttendanceSummary({
    required this.presentDays,
    required this.lateDays,
    required this.absentDays,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      presentDays: json['presentDays'] ?? 0,
      lateDays: json['lateDays'] ?? 0,
      absentDays: json['absentDays'] ?? 0,
    );
  }
}