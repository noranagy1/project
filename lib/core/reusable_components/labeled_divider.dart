import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';

class LabeledDivider extends StatelessWidget {
  final String text;
  final bool isDark;
  const LabeledDivider({super.key, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final lineColor = isDark ? ColorManager.darkDivider : ColorManager.lightBorder;
    final textColor = isDark ? ColorManager.darkTextMuted : ColorManager.lightTextMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: lineColor, thickness: 1, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(text.toUpperCase(),
              style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4),
            ),
          ),
          Expanded(child: Divider(color: lineColor, thickness: 1, height: 1)),
        ],
      ),
    );
  }
}