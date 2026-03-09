import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:flutter/material.dart';
// ─────────────────────────────────────────
//  ROLE CHIPS
//  - Employee / Security
//  - بيتضاف في signup_screen.dart
// ─────────────────────────────────────────
enum UserRole { employee, security }
class RoleChips extends StatelessWidget {
  final UserRole? selectedRole;
  final ValueChanged<UserRole> onChanged;
  final bool isDark;
  const RoleChips({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──────────────────────
        Text(
          'Role',
          style: TextStyle(
            color: isDark
                ? ColorManager.darkTextSecond
                : ColorManager.lightTextMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),

        const SizedBox(height: 8),

        // ── Chips ───────────────────────
        Row(
          children: [
            Expanded(
              child: _RoleChip(
                label: context.l10n.employee,
                icon: Icons.person_rounded,
                role: UserRole.employee,
                isSelected: selectedRole == UserRole.employee,
                isDark: isDark,
                onTap: () => onChanged(UserRole.employee),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RoleChip(
                label: context.l10n.security,
                icon: Icons.security_rounded,
                role: UserRole.security,
                isSelected: selectedRole == UserRole.security,
                isDark: isDark,
                onTap: () => onChanged(UserRole.security),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  SINGLE CHIP
// ─────────────────────────────────────────

class _RoleChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final UserRole role;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.role,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_RoleChip> createState() => _RoleChipState();
}

class _RoleChipState extends State<_RoleChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeInOut,
          height: 48,
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
              colors: [ColorManager.blue, ColorManager.blueDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: widget.isSelected
                ? null
                : (widget.isDark
                ? Colors.white.withOpacity(0.04)
                : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : (widget.isDark
                  ? Colors.white.withOpacity(0.08)
                  : const Color(0xFFE2E8F0)),
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: ColorManager.blue.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isSelected
                    ? Colors.white
                    : (widget.isDark
                    ? ColorManager.darkTextSecond
                    : ColorManager.lightTextMuted),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected
                      ? Colors.white
                      : (widget.isDark
                      ? ColorManager.darkTextSecond
                      : ColorManager.lightTextMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}