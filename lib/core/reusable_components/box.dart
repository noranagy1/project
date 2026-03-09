import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/utils/app_icons.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────
//  MAIN BOX  —  Camera & Gate  (with toggle)
// ─────────────────────────────────────────
enum MainBoxType { camera, gate }
class MainBox extends StatefulWidget {
  final MainBoxType type;
  final bool isDark;
  final VoidCallback? onTap;
  const MainBox({
    super.key,
    required this.type,
    required this.isDark,
    this.onTap,
  });
  @override
  State<MainBox> createState() => _MainBoxState();
}
class _MainBoxState extends State<MainBox> with SingleTickerProviderStateMixin {
  bool _isOn = false;
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;
  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut);
  }
  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }
  bool get _isCamera => widget.type == MainBoxType.camera;
  // ── Colors per type & theme ────────────
  Color get _iconBg => widget.isDark
      ? (_isCamera ? ColorManager.darkCameraIconBg : ColorManager.darkGateIconBg)
      : (_isCamera ? ColorManager.lightCameraIconBg : ColorManager.lightGateIconBg);
  Color get _iconColor => widget.isDark
      ? (_isCamera ? ColorManager.darkCameraIcon : ColorManager.darkGateIcon)
      : (_isCamera ? ColorManager.blue : ColorManager.emeraldDk);
  Color get _borderColor => widget.isDark
      ? (_isCamera ? ColorManager.darkCameraBorder : ColorManager.darkGateBorder)
      : (_isCamera ? ColorManager.lightCameraBorder : ColorManager.lightGateBorder);
  Color get _glowColor => widget.isDark
      ? (_isCamera ? ColorManager.darkCameraGlow : ColorManager.darkGateGlow)
      : (_isCamera ? ColorManager.lightCameraGlow : ColorManager.lightGateGlow);
  Color get _toggleActiveColor =>
      _isCamera ? ColorManager.blue : ColorManager.emerald;
  List<Color> get _cardGradient => widget.isDark
      ? [ColorManager.darkCard, ColorManager.darkCardDeep]
      : [const Color(0xFFF1F5F9), const Color(0xFFE8EFF7)];
  Color get _textColor => widget.isDark
      ? ColorManager.darkTextPrimary.withOpacity(0.9)
      : ColorManager.lightTextPrimary.withOpacity(0.8);
  String get _title => _isCamera ? 'Camera Control' : 'Gate Control';
  IconData get _icon => _isCamera ? AppIcons.camera : AppIcons.gate;
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _cardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: _glowColor,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ─────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon, color: _iconColor, size: 30),
              ),
              const Spacer(),
              // ── Title ─────────────────
              Text(
                _title,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              // ── Toggle ────────────────
              _AppToggle(
                value: _isOn,
                activeColor: _toggleActiveColor,
                isDark: widget.isDark,
                onChanged: (v) => setState(() => _isOn = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────
//  SMALL BOX  —  Attendance, Report, etc.
// ─────────────────────────────────────────
enum SmallBoxType { attendanceQr, report, complaint, gateStatus, vehicleReport }
enum SmallBoxSize { large, small }
class SmallBox extends StatefulWidget {
  final SmallBoxType type;
  final bool isDark;
  final VoidCallback? onTap;
  final SmallBoxSize size;
  const SmallBox({
    this.size = SmallBoxSize.large,
    super.key,
    required this.type,
    required this.isDark,
    this.onTap,
  });
  double get height {
    switch (size) {
      case SmallBoxSize.large: return 150;
      case SmallBoxSize.small: return 120;
    }
  }
  @override
  State<SmallBox> createState() => _SmallBoxState();
}
class _SmallBoxState extends State<SmallBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;
  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut);
  }
  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }
  // ── Per-type config ────────────────────
  Color get _accentColor {
    switch (widget.type) {
      case SmallBoxType.attendanceQr: return ColorManager.blue;
      case SmallBoxType.report:     return ColorManager.sky;
      case SmallBoxType.complaint:  return ColorManager.purple;
      case SmallBoxType.gateStatus: return ColorManager.amber;
      case SmallBoxType.vehicleReport: return ColorManager.amber;
    }
  }
  Color get _iconBg {
    switch (widget.type) {
      case SmallBoxType.attendanceQr:
        return widget.isDark ? ColorManager.darkBlueAccent   : ColorManager.lightBlueAccent;
      case SmallBoxType.report:
        return widget.isDark ? ColorManager.darkSkyAccent    : ColorManager.lightSkyAccent;
      case SmallBoxType.complaint:
        return widget.isDark ? ColorManager.darkPurpleAccent : ColorManager.lightPurpleAccent;
      case SmallBoxType.gateStatus:
        return widget.isDark ? ColorManager.darkAmberAccent  : ColorManager.lightAmberAccent;
      case SmallBoxType.vehicleReport:
        return widget.isDark ? ColorManager.darkAmberAccent  : ColorManager.lightAmberAccent;
    }
  }
  Color get _borderColor {
    return _accentColor.withOpacity(widget.isDark ? 0.22 : 0.18);
  }
  String get _title {
    switch (widget.type) {
      case SmallBoxType.attendanceQr: return 'Attendance\nQr Code';
      case SmallBoxType.report:     return context.l10n.attendance_report;
      case SmallBoxType.complaint:  return context.l10n.submit_complaint;
      case SmallBoxType.gateStatus: return 'Gate and camera \n Status';
      case SmallBoxType.vehicleReport: return context.l10n.vehicle_report;
    }
  }
  IconData get _icon {
    switch (widget.type) {
      case SmallBoxType.attendanceQr: return AppIcons.attendance;
      case SmallBoxType.report:     return AppIcons.report;
      case SmallBoxType.complaint:  return AppIcons.complaint;
      case SmallBoxType.gateStatus: return AppIcons.gateStatus;
      case SmallBoxType.vehicleReport: return AppIcons.vehicleReport;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _scaleCtrl.reverse(),
      onTapUp: (_) => _scaleCtrl.forward(),
      onTapCancel: () => _scaleCtrl.forward(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: SizedBox(
          height: widget.height,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? ColorManager.darkProfileBg
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
              boxShadow: widget.isDark
                  ? []
                  : [
                BoxShadow(
                  color: _accentColor.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon ─────────────────
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_icon, color: _accentColor, size: 25),
                ),
                const SizedBox(height: 10),
                // ── Title ─────────────────
                Text(
                  _title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.isDark
                        ? ColorManager.darkTextPrimary
                        : ColorManager.lightTextPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────
//  TOGGLE  —  Light & Dark
// ─────────────────────────────────────────
class _AppToggle extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final bool isDark;
  final ValueChanged<bool> onChanged;
  const _AppToggle({
    required this.value,
    required this.activeColor,
    required this.isDark,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: 42,
        height: 23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value
              ? activeColor
              : (isDark ? ColorManager.darkToggleOff : ColorManager.lightToggleOff),
          border: value
              ? null
              : Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : ColorManager.lightBorder,
          ),
          boxShadow: value
              ? [
            BoxShadow(
              color: activeColor.withOpacity(0.3),
              blurRadius: 0,
              spreadRadius: 2,
            ),
          ]
              : [],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              left: value ? 21 : 3,
              top: 3,
              child: Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}