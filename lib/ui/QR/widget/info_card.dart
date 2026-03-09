import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
// ─────────────────────────────────────────
//  USER INFO CARD
//  - بيعرض اسم ومعلومات المستخدم
//  - بيتحل فيه data من الـ backend / local
// ─────────────────────────────────────────
class UserInfoCard extends StatefulWidget {
  final bool isDark;

  // TODO: استبدل بـ User model من الـ backendطب
  final String userName;
  final String userEmail;

  const UserInfoCard({

    super.key,
    required this.isDark,
    required this.userName,
    required this.userEmail,
  });
  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}
class _UserInfoCardState extends State<UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isDark
            ? ColorManager.darkProfileBg
            : ColorManager.lightProfileBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.07)
              : ColorManager.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // ── Avatar ───────────────────
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ColorManager.blue, ColorManager.blueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // ── Name & email ─────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: widget.isDark
                        ? ColorManager.darkTextPrimary
                        : ColorManager.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.userEmail,
                  style: TextStyle(
                    color: widget.isDark
                        ? ColorManager.darkTextSecond
                        : ColorManager.lightTextSecond,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Active badge ─────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ColorManager.emerald.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorManager.emerald.withOpacity(0.2),
              ),
            ),
            child: Text(
              'Active',
              style: TextStyle(
                color: ColorManager.emerald,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}