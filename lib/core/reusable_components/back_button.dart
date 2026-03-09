import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendo/providers/theme_provider.dart';
// ─────────────────────────────────────────
//  BACK BUTTON  —  مشترك في كل شاشات الـ OTP
// ─────────────────────────────────────────
class BackButton extends StatelessWidget {
  const BackButton({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : const Color(0xFFF1F5F9),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : ColorManager.lightBorder,
          ),
        ),
        child: Icon(
          Icons.chevron_left_rounded,
          color: isDark ? ColorManager.darkTextSecond : const Color(0xFF64748B),
          size: 22,
        ),
      ),
    );
  }
}