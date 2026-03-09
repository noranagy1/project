import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class AuthInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isDark;
  String? Function(String?) validator; /// ال validator عبارة عن function بتاخد النص اللي اتكتب ولو فيه خطأ بترجع رسالة خطأ، ولو صح بترجع null
  final bool isPassword;
  final TextInputType? keyboardType;
  AuthInputField({
    super.key,
    required this.label,
     this.hint,
    required this.controller,
    required this.isDark,
    this.isPassword = false,
    this.keyboardType,
    required this.validator,
  });
  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}
class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscure = true;
  bool _focused = false;
  late final FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _focused = _focusNode.hasFocus);
      });
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? ColorManager.blue.withOpacity(0.5)
        : (widget.isDark
        ? Colors.white.withOpacity(0.08)
        : ColorManager.lightBorder);
    final fillColor = widget.isDark
        ? Colors.white.withOpacity(0.04)
        : const Color(0xFFF8FAFC);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──────────────────────
        Text(
          widget.label,
          style: TextStyle(
            color: widget.isDark
                ? ColorManager.darkTextSecond
                : ColorManager.lightTextMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 6),
        // ── Input ──────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _focused
                ? [
              BoxShadow(
                color: ColorManager.blue.withOpacity(
                    widget.isDark ? 0.1 : 0.08),
                blurRadius: 0,
                spreadRadius: 3,
              ),
            ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction, /// السطر ده بيخلي التحقق يظهر بعد ما المستخدم يبدأ يكتب في الحقل
            focusNode: _focusNode,
            obscureText: widget.isPassword && _obscure,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              color: widget.isDark
                  ? ColorManager.darkTextPrimary
                  : ColorManager.lightTextPrimary,
              fontSize: 13.5,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.isDark
                    ? ColorManager.darkTextSecond
                    : const Color(0xFF94A3B8),
                fontSize: 13.5,
              ),
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.08)
                      : ColorManager.lightBorder,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorManager.blue.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              // Eye icon لو password
              suffixIcon: widget.isPassword
                  ? IconButton(
                onPressed: () =>
                    setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: widget.isDark
                      ? ColorManager.darkIconMuted
                      : ColorManager.lightIconMuted,
                ),
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}