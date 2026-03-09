import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  APP ICONS  —  كل الأيقونات في الشاشة
// ─────────────────────────────────────────
//
//  Flutter built-in Icons بدل SVG
//  لو عندك assets صور استخدمي Image.asset()

class AppIcons {
  // ── Top bar ────────────────────────────
  /// أيقونة المبنى (يسار الهيدر)
  static const building   = Icons.business_rounded;

  /// قائمة النقاط الثلاث (يمين الهيدر)
  static const moreVert   = Icons.more_vert_rounded;

  // ── Profile ────────────────────────────
  /// أيقونة الشخص داخل الأفاتار
  static const person     = Icons.person_rounded;

  /// السهم اليمين في كارت البروفايل
  static const chevronRight = Icons.chevron_right_rounded;

  // ── Main cards (Camera & Gate) ─────────
  /// كارت التحكم في الكاميرا
  static const camera     = Icons.camera_alt_rounded;

  /// كارت التحكم في البوابة
  static const gate       = Icons.meeting_room_rounded;

  // ── Secondary cards ────────────────────
  /// Attendance
  static const attendance = Icons.people_alt_rounded;

  /// Attendance Report
  static const report     = Icons.insert_drive_file_rounded;

  /// Submit Complaint
  static const complaint  = Icons.chat_bubble_outline_rounded;

  /// Gate Status
  static const gateStatus = Icons.access_time_rounded;
  static const vehicleReport = Icons.car_repair_rounded;
}
// ─────────────────────────────────────────
//  ICON WIDGET HELPER
//  استخدميه عشان توحدي الـ size والـ color
// ─────────────────────────────────────────
class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AppIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size);
  }
}