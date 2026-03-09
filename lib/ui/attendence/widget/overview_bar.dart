import 'package:attendo/core/color_manager.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/ui/attendence/widget/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────
//  REPORT OVERVIEW BAR
//  شريط ألوان يوضح النسب دفعة واحدة
// ─────────────────────────────────────────
class ReportOverviewBar extends StatelessWidget {
  final AttendanceSummary summary;
  const ReportOverviewBar({
    super.key,
    required this.summary,
    required bool isDark,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final total = summary.totalDays;
    final segments = [
      _Segment(label: 'Present', value: summary.presentDays - summary.lateDays, color: ColorManager.blue),
      _Segment(label: 'Late',    value: summary.lateDays,                        color: ColorManager.amber),
      _Segment(label: 'Absent',  value: summary.absentDays,                      color: ColorManager.purple),
    ].where((s) => s.value > 0).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
        ),
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Overview',
                style: TextStyle(
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$total days',
                style: TextStyle(
                  color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                for (int i = 0; i < segments.length; i++)
                  Flexible(
                    flex: segments[i].value,
                    child: Container(
                      height: 8,
                      color: segments[i].color,
                      margin: EdgeInsets.only(right: i < segments.length - 1 ? 2 : 0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            children: [
              _LegendItem(color: ColorManager.blue,   label: 'Present', isDark: isDark),
              const SizedBox(width: 16),
              _LegendItem(color: ColorManager.amber,  label: 'Late',    isDark: isDark),
              const SizedBox(width: 16),
              _LegendItem(color: ColorManager.purple, label: 'Absent',  isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}
class _Segment {
  final String label;
  final int value;
  final Color color;
  const _Segment({required this.label, required this.value, required this.color});
}
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label, required bool isDark, });
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}