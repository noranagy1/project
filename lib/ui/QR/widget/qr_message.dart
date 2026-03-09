import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  QR SCAN MESSAGE
//  - بتظهر تحت الـ QR بعد ما الـ backend
//    يبعت response
//  - تختفي تلقائي بعد 3 ثواني
// ─────────────────────────────────────────

class QrScanMessage extends StatefulWidget {
  final bool isSuccess;
  final bool isDark;

  const QrScanMessage({
    super.key,
    required this.isSuccess,
    required this.isDark,
  });

  @override
  State<QrScanMessage> createState() => _QrScanMessageState();
}

class _QrScanMessageState extends State<QrScanMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressCtrl;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.isSuccess;
    final isDark    = widget.isDark;

    // ── Colors ───────────────────────────
    final bgColor     = isSuccess
        ? ColorManager.emerald.withOpacity(0.08)
        : ColorManager.red.withOpacity(0.08);
    final borderColor = isSuccess
        ? ColorManager.emerald.withOpacity(0.2)
        : ColorManager.red.withOpacity(0.2);
    final textColor   = isSuccess
        ? ColorManager.emerald
        : ColorManager.red;
    final icon = isSuccess
        ? Icons.check_circle_rounded
        : Icons.cancel_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: textColor, size: 24),
              ),

              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSuccess
                          ? 'تم تسجيل حضورك'
                          : 'فشل التسجيل',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isSuccess
                          ? 'تم تسجيل حضورك بنجاح'
                          : 'حدث خطأ أثناء التسجيل، حاول مرة أخرى',
                      style: TextStyle(
                        color: isDark
                            ? ColorManager.darkTextSecond
                            : ColorManager.lightTextSecond,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Progress bar ─────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: AnimatedBuilder(
              animation: _progressCtrl,
              builder: (_, __) => LinearProgressIndicator(
                value: 1 - _progressCtrl.value,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
                minHeight: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}