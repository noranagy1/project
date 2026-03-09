import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class AuthTitle extends StatelessWidget {
  final bool isDark;
  final String title;
  final String subtitle;
  const AuthTitle({super.key, required this.isDark, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}