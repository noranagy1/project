import 'package:attendo/core/color_manager.dart';
import 'package:attendo/ui/attendence/widget/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
// ─────────────────────────────────────────
//  REPORT SUMMARY CARDS
//  3 cards: Present / Late / Absent
// ─────────────────────────────────────────
class ReportSummaryCards extends StatelessWidget {
  final AttendanceSummary summary;
  final bool isDark;
  const ReportSummaryCards({
    super.key,
    required this.summary,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final cards = [
      _CardData(
        label: 'Present',
        value: summary.presentDays,
        color: ColorManager.blue,
        borderColor: ColorManager.blue.withOpacity(0.3),
        icon: '✅',
      ),
      _CardData(
        label: 'Late',
        value: summary.lateDays,
        color: ColorManager.amber,
        borderColor: ColorManager.amber.withOpacity(0.3),
        icon: '🕐',
      ),
      _CardData(
        label: 'Absent',
        value: summary.absentDays,
        color: ColorManager.purple,
        borderColor: ColorManager.purple.withOpacity(0.3),
        icon: '❌',
      ),
    ];
    return Row(
      children: cards
          .map((c) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            right: c == cards.last ? 0 : 10,
          ),
          child: _SummaryCard(data: c, isDark: isDark),
        ),
      ))
          .toList(),
    );
  }
}
class _CardData {
  final String label;
  final int value;
  final Color color;
  final Color borderColor;
  final String icon;
  const _CardData({
    required this.label,
    required this.value,
    required this.color,
    required this.borderColor,
    required this.icon,
  });
}
class _SummaryCard extends StatelessWidget {
  final _CardData data;
  const _SummaryCard({required this.data, required bool isDark,});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.borderColor, width: 1.5),
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            '${data.value}',
            style: TextStyle(
              color: data.color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            style: TextStyle(
              color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}