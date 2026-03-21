import 'dart:convert';
import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
class QrCard extends StatelessWidget {
  final bool isDark;
  final String qrData; // base64 image من السيرفر
  const QrCard({
    super.key,
    required this.isDark,
    this.qrData = '',
  });
  // ── تحويل base64 لـ bytes ──────────────
  Uint8List? get _imageBytes {
    try {
      final base64Str = qrData.contains(',')
          ? qrData.split(',').last // شيل الـ "data:image/png;base64," prefix
          : qrData;
      return base64Decode(base64Str);
    } catch (_) {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    final bytes = _imageBytes;
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
                  child: bytes != null
                      ? Image.memory( // ✅ عرض الصورة الجاهزة من السيرفر
                    bytes,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  )
                      : const SizedBox( // لو فشل التحويل
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Icon(Icons.qr_code_2_rounded,
                          size: 80, color: Colors.grey),
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
                    const Text(
                      'midnight',
                      style: TextStyle(
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
      Positioned(
        top: 0, left: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              top:  BorderSide(color: color, width: thickness),
              left: BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24)),
          ),
        ),
      ),
      Positioned(
        top: 0, right: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              top:   BorderSide(color: color, width: thickness),
              right: BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(topRight: Radius.circular(24)),
          ),
        ),
      ),
      Positioned(
        bottom: 0, left: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: thickness),
              left:   BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24)),
          ),
        ),
      ),
      Positioned(
        bottom: 0, right: 0,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: thickness),
              right:  BorderSide(color: color, width: thickness),
            ),
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
          ),
        ),
      ),
    ];
  }
}