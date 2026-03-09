import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
// ─────────────────────────────────────────
//  PROFILE HEADER  —  Light & Dark
// ─────────────────────────────────────────
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final bool isDark;
  final VoidCallback onTap;
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.isDark,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? ColorManager.darkProfileBg
              : ColorManager.lightProfileBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? ColorManager.darkBorder
                : ColorManager.lightBorder,
          ),
        ),
        child: Row(
          children: [
            // ── Avatar ───────────────────
            Container(
              width: 44,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: const LinearGradient(
                  colors: [ColorManager.blue, ColorManager.blueDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                AppIcons.person,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // ── Name + Email ─────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isDark
                          ? ColorManager.darkTextPrimary
                          : ColorManager.lightTextPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(
                      color: isDark
                          ? ColorManager.darkTextSecond
                          : ColorManager.lightTextSecond,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            // ── Chevron ──────────────────
            Icon(
              AppIcons.chevronRight,
              color: isDark
                  ? ColorManager.darkTextMuted
                  : ColorManager.lightBorder,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}