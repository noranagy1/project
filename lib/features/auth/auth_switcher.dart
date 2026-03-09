import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final bool isDark;
  final ValueChanged<bool> onChanged;
  const AuthTabSwitcher({
    super.key,
    required this.isLogin,
    required this.isDark,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : ColorManager.lightBorder,
        ),
      ),
      child: Row(
        children: [
          _TabBtn(
            label: 'Log In',
            isSelected: isLogin,
            isDark: isDark,
            onTap: () => onChanged(true),
          ),
          _TabBtn(
            label: 'Sign Up',
            isSelected: !isLogin,
            isDark: isDark,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}
class _TabBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  const _TabBtn({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? ColorManager.darkCard : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark
                    ? ColorManager.darkTextPrimary
                    : ColorManager.lightTextPrimary)
                    : (isDark
                    ? ColorManager.darkTextSecond
                    : ColorManager.lightTextSecond),
              ),
            ),
          ),
        ),
      ),
    );
  }
}