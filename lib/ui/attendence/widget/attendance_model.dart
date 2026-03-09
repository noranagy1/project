// ─────────────────────────────────────────
//  ATTENDANCE REPORT MODELS
//  بيمثل الـ response الجاي من الـ API
// ─────────────────────────────────────────
enum AttendanceStatus { present, late, absent }
extension AttendanceStatusX on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.present: return 'Present';
      case AttendanceStatus.late:    return 'Late';
      case AttendanceStatus.absent:  return 'Absent';
    }
  }
  static AttendanceStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'present': return AttendanceStatus.present;
      case 'late':    return AttendanceStatus.late;
      default:        return AttendanceStatus.absent;
    }
  }
}
// ── Summary ───────────────────────────────
class AttendanceSummary {
  final int presentDays;
  final int lateDays;
  final int absentDays;
  const AttendanceSummary({
    required this.presentDays,
    required this.lateDays,
    required this.absentDays,
  });
  int get totalDays => presentDays + absentDays;
  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      presentDays: json['presentDays'] as int,
      lateDays:    json['lateDays']    as int,
      absentDays:  json['absentDays']  as int,
    );
  }
}
// ── Day Detail ────────────────────────────
class DayDetail {
  final String date;        // "2026-02-27"
  final DateTime? checkIn;
  final DateTime? checkOut;
  final AttendanceStatus status;
  const DayDetail({
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });
  // مدة الحضور بالدقائق
  int? get durationMinutes {
    if (checkIn == null || checkOut == null) return null;
    return checkOut!.difference(checkIn!).inMinutes;
  }
  String get durationLabel {
    final mins = durationMinutes;
    if (mins == null) return '--';
    final h = mins ~/ 60;
    final m = mins % 60;
    return '${h}h ${m}m';
  }
  factory DayDetail.fromJson(String date, Map<String, dynamic> json) {
    return DayDetail(
      date:     date,
      checkIn:  json['checkIn']  != null ? DateTime.parse(json['checkIn'])  : null,
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      status:   AttendanceStatusX.fromString(json['status'] as String),
    );
  }
}
// ── Monthly Report ────────────────────────
class MonthlyReport {
  final AttendanceSummary summary;
  final List<DayDetail> details;
  const MonthlyReport({
    required this.summary,
    required this.details,
  });
  // بيجمع الأيام في weeks
  List<WeekGroup> get weekGroups {
    final sorted = [...details]
      ..sort((a, b) => b.date.compareTo(a.date));
    final Map<int, List<DayDetail>> byWeek = {};
    for (final day in sorted) {
      final d = DateTime.parse(day.date);
      final weekNum = ((d.day - 1) ~/ 7) + 1;
      byWeek.putIfAbsent(weekNum, () => []).add(day);
    }
    return byWeek.entries
        .map((e) => WeekGroup(weekNumber: e.key, days: e.value))
        .toList()
      ..sort((a, b) => b.weekNumber.compareTo(a.weekNumber));
  }
  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    final detailsMap = json['details'] as Map<String, dynamic>;
    final details = detailsMap.entries
        .map((e) => DayDetail.fromJson(e.key, e.value as Map<String, dynamic>))
        .toList();
    return MonthlyReport(
      summary: AttendanceSummary.fromJson(json['summary']),
      details: details,
    );
  }
}
// ── Week Group ────────────────────────────
class WeekGroup {
  final int weekNumber;
  final List<DayDetail> days;
  const WeekGroup({required this.weekNumber, required this.days});
  String get label => 'Week $weekNumber';
  Map<AttendanceStatus, int> get statusCounts {
    final map = <AttendanceStatus, int>{};
    for (final d in days) {
      map[d.status] = (map[d.status] ?? 0) + 1;
    }
    return map;
  }
}