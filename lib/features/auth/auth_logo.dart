import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class AuthLogo extends StatelessWidget {
  final bool isDark;
  const AuthLogo({super.key, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCameraIconBg : ColorManager.lightTopIconBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ColorManager.darkCameraBorder : ColorManager.lightTopIconBorder,
        ),
      ),
      child: const Icon(
        Icons.meeting_room_rounded,
        color: ColorManager.blue,
        size: 30,
      ),
    );
  }
}