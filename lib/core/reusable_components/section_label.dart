import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const SectionLabel({super.key, required this.text, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isDark ? ColorManager.darkTextMuted : ColorManager.lightTextMuted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}