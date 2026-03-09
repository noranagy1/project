import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// ─────────────────────────────────────────
//  QR CARD
//  - بيعرض الـ QR الخاص بالمستخدم
//  - الـ QR بيتجدد كل يوم عند منتص الليل
//  - الـ qrData بيجي من الـ backend
// ─────────────────────────────────────────
//
//  Package مطلوب في pubspec.yaml:
//    qr_flutter: ^4.1.0
class QrCard extends StatelessWidget {
  final bool isDark;
  // مثال: قيمة مشفرة unique لكل مستخدم + تاريخ اليوم
  final String qrData;
  const QrCard({
    super.key,
    required this.isDark,
    this.qrData = 'USER_ID_20260306', // placeholder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.lightPhone,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? ColorManager.blue.withOpacity(0.15)
              : ColorManager.blue.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : ColorManager.blue.withOpacity(0.08),
            blurRadius: isDark ? 30 : 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Corner decorations ────────
          ..._buildCorners(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 35, 24, 24),
            child: Column(
              children: [
                // ── QR Image ─────────────
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? ColorManager.blue.withOpacity(0.1)
                            : Colors.black.withOpacity(0.07),
                        blurRadius: isDark ? 40 : 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF111827),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Refresh notice ────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: isDark
                          ? ColorManager.darkTextSecond
                          : ColorManager.lightTextSecond,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Refreshes daily at ',
                      style: TextStyle(
                        color: isDark
                            ? ColorManager.darkTextSecond
                            : ColorManager.lightTextSecond,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'midnight',
                      style: const TextStyle(
                        color: ColorManager.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Corner decorations ─────────────────
  List<Widget> _buildCorners() {
    const size = 28.0;
    const thickness = 2.0;
    final color = ColorManager.blue;

    return [
      // Top-left
      Positioned(
        top: 0, left: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              top:  BorderSide(color: color, width: thickness),
              left: BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0, right: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              top:   BorderSide(color: color, width: thickness),
              right: BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0, left: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: thickness),
              left:   BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0, right: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: thickness),
              right:  BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
      ),
    ];
  }
}