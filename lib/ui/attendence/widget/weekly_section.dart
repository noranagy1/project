import 'package:attendo/core/color_manager.dart';
import 'package:attendo/ui/attendence/widget/attendance_model.dart';
import 'package:flutter/material.dart';


// ─────────────────────────────────────────
//  REPORT WEEK SECTION
//  Week header + day rows
// ─────────────────────────────────────────

class ReportWeekSection extends StatelessWidget {
  final WeekGroup week;
  final bool isDark;

  const ReportWeekSection({
    super.key,
    required this.week,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Week header ───────────────
        _WeekHeader(week: week, isDark: isDark),
        const SizedBox(height: 8),

        // ── Day rows ──────────────────
        ...week.days.map((day) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _DayRow(day: day, isDark: isDark),
        )),
      ],
    );
  }
}

// ── Week Header ───────────────────────────
class _WeekHeader extends StatelessWidget {
  final WeekGroup week;
  final bool isDark;

  const _WeekHeader({required this.week, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Text(
            week.label,
            style: TextStyle(
              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          // Status badges
          Row(
            children: week.statusCounts.entries.map((e) {
              final cfg = _statusConfig(e.key);
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cfg.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${e.value}',
                        style: TextStyle(color: cfg.color, fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        e.key.label,
                        style: TextStyle(color: cfg.color, fontSize: 8, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Day Row ───────────────────────────────
class _DayRow extends StatelessWidget {
  final DayDetail day;
  final bool isDark;

  const _DayRow({required this.day, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cfg      = _statusConfig(day.status);
    final isAbsent = day.status == AttendanceStatus.absent;
    final d        = DateTime.parse(day.date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF1F5F9),
        ),
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          // ── Date box ───────────────
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: isAbsent
                  ? cfg.bg
                  : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAbsent
                    ? cfg.border
                    : (isDark ? Colors.white.withOpacity(0.08) : ColorManager.lightBorder),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  d.day.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: isAbsent ? cfg.color : (isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary),
                    fontSize: 15, fontWeight: FontWeight.w800, height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _weekdayShort(d.weekday),
                  style: TextStyle(
                    color: isAbsent ? cfg.color : (isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond),
                    fontSize: 9, fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Content ────────────────
          Expanded(
            child: isAbsent
                ? _AbsentContent(cfg: cfg, isDark: isDark)
                : _AttendanceContent(day: day, cfg: cfg, isDark: isDark),
          ),

          const SizedBox(width: 10),

          // ── Status badge ───────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cfg.bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cfg.border),
            ),
            child: Text(
              day.status.label,
              style: TextStyle(color: cfg.color, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Absent content ────────────────────────
class _AbsentContent extends StatelessWidget {
  final _StatusCfg cfg;
  final bool isDark;

  const _AbsentContent({required this.cfg, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cfg.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cfg.border),
          ),
          child: Text('Absent', style: TextStyle(color: cfg.color, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 4),
        Text(
          'No attendance recorded',
          style: TextStyle(
            color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

// ── Attendance content ────────────────────
class _AttendanceContent extends StatelessWidget {
  final DayDetail day;
  final _StatusCfg cfg;
  final bool isDark;

  const _AttendanceContent({required this.day, required this.cfg, required this.isDark});

  String _fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final sepColor = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9);
    return IntrinsicHeight(
      child: Row(
        children: [
          _TimeCell(icon: '●', iconColor: ColorManager.emerald, label: 'Check In',  value: _fmt(day.checkIn),  isDark: isDark),
          VerticalDivider(color: sepColor, width: 1, thickness: 1),
          _TimeCell(icon: '●', iconColor: ColorManager.red,     label: 'Check Out', value: _fmt(day.checkOut), isDark: isDark),
          VerticalDivider(color: sepColor, width: 1, thickness: 1),
          _TimeCell(icon: '⏱', iconColor: ColorManager.blue,    label: 'Total',     value: day.durationLabel,  isDark: isDark),
        ],
      ),
    );
  }
}

class _TimeCell extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDark;

  const _TimeCell({
    required this.icon, required this.iconColor,
    required this.label, required this.value, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(color: iconColor, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                fontSize: 11, fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────
class _StatusCfg {
  final Color color, bg, border;
  const _StatusCfg({required this.color, required this.bg, required this.border});
}

_StatusCfg _statusConfig(AttendanceStatus s) {
  switch (s) {
    case AttendanceStatus.present:
      return _StatusCfg(color: ColorManager.blue,   bg: ColorManager.blue.withOpacity(0.1),   border: ColorManager.blue.withOpacity(0.2));
    case AttendanceStatus.late:
      return _StatusCfg(color: ColorManager.amber,  bg: ColorManager.amber.withOpacity(0.1),  border: ColorManager.amber.withOpacity(0.2));
    case AttendanceStatus.absent:
      return _StatusCfg(color: ColorManager.purple, bg: ColorManager.purple.withOpacity(0.1), border: ColorManager.purple.withOpacity(0.2));
  }
}

String _weekdayShort(int weekday) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[weekday - 1];
}