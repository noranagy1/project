import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
// ─────────────────────────────────────────
//  OTP INPUT BOX  —  Single digit cell
// ─────────────────────────────────────────
class OtpInputBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? prevFocus;
  const OtpInputBox({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.prevFocus,
  });
  @override
  State<OtpInputBox> createState() => _OtpInputBoxState();
}
class _OtpInputBoxState extends State<OtpInputBox> {
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _focused = widget.focusNode.hasFocus);
    });
  }
  @override
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }
  bool get _filled => widget.controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 52, height: 58,
      decoration: BoxDecoration(
        color: _filled
            ? (isDark
            ? ColorManager.blue.withOpacity(0.1)
            : const Color(0xFFEFF6FF))
            : (isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _filled || _focused
              ? ColorManager.blue
              : (isDark
              ? Colors.white.withOpacity(0.12)
              : ColorManager.lightBorder),
          width: 1.5,
        ),
        boxShadow: _filled || _focused
            ? [BoxShadow(color: ColorManager.blue.withOpacity(0.15), blurRadius: 0, spreadRadius: 3)]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          fontSize: 22, fontWeight: FontWeight.w800,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (val) {
          if (val.isNotEmpty && widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          }
          setState(() {});
        },
        onTap: () {
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        },
      ),
    );
  }
}