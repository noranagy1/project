class AttendanceModel {
  final int presentDays;
  final int lateDays;
  final int absentDays;
  final Map<String, DayAttendance> details;
  AttendanceModel({
    required this.presentDays,
    required this.lateDays,
    required this.absentDays,
    required this.details,
  });
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'];
    final detailsMap = json['details'] as Map<String, dynamic>;
    return AttendanceModel(
      presentDays: summary['presentDays'] ?? 0,
      lateDays: summary['lateDays'] ?? 0,
      absentDays: summary['absentDays'] ?? 0,
      details: detailsMap.map(
            (key, value) => MapEntry(key, DayAttendance.fromJson(value)),
      ),
    );
  }
}
class DayAttendance {
  final String? checkIn;
  final String? checkOut;
  final String status;
  DayAttendance({
    this.checkIn,
    this.checkOut,
    required this.status,
  });
  factory DayAttendance.fromJson(Map<String, dynamic> json) {
    return DayAttendance(
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      status: json['status'] ?? 'Absent',
    );
  }
}