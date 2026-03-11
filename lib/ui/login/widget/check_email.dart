import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/widget/otp_box.dart';
import 'package:attendo/ui/login/widget/set_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _controllers   = List.generate(5, (_) => TextEditingController());
  final _focusNodes    = List.generate(5, (_) => FocusNode());
  final _keyboardNodes = List.generate(5, (_) => FocusNode()); // ✅ مش FocusNode() في الـ build
  bool _isLoading   = false;
  bool _isResending = false;
  final _repo = AuthRepo();

  String get _otpCode   => _controllers.map((c) => c.text).join();
  bool   get _isComplete => _otpCode.length == 5;

  @override
  void dispose() {
    for (final c in _controllers)   c.dispose();
    for (final f in _focusNodes)    f.dispose();
    for (final f in _keyboardNodes) f.dispose(); // ✅
    super.dispose();
  }

  // ── Verify ────────────────────────────
  Future<void> _verifyCode() async {
    if (!_isComplete) return;
    setState(() => _isLoading = true);
    try {
      final resetToken = await _repo.verifyOtp(widget.email, _otpCode);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack("Email Sent"),
      );      Navigator.push(context, MaterialPageRoute(
        builder: (_) => SetPasswordScreen(resetToken: resetToken),
      ));
    } on ApiError catch (e) {
      if (!mounted) return; // ✅
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(e.message, isError: true),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // ── Resend ────────────────────────────
  Future<void> _resend() async {
    setState(() => _isResending = true);
    try {
      await _repo.forgotPassword(widget.email);
      if (!mounted) return; // ✅
      ScaffoldMessenger.of(context).showSnackBar(customSnack('Code resent!'));
    } on ApiError catch (e) {
      if (!mounted) return; // ✅
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(e.message, isError: true),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _handleBackspace(int index, String val) {
    if (val.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBg : ColorManager.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(),
              const SizedBox(height: 32),
              Text(
                'Check your email',
                style: TextStyle(
                  color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                  fontSize: 26, fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                    fontSize: 14, height: 1.6,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a reset code to '),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(color: ColorManager.blue, fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' — enter the 5 digit code'),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (i) {
                  return KeyboardListener(
                    focusNode: _keyboardNodes[i], // ✅
                    onKeyEvent: (event) {
                      if (event.logicalKey.keyLabel == 'Backspace') {
                        _handleBackspace(i, _controllers[i].text);
                      }
                    },
                    child: OtpInputBox(
                      controller: _controllers[i],
                      focusNode:  _focusNodes[i],
                      nextFocus:  i < 4 ? _focusNodes[i + 1] : null,
                      prevFocus:  i > 0 ? _focusNodes[i - 1] : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              AuthButton(
                label: 'Verify Code',
                isLoading: _isLoading,
                onTap: _verifyCode, // ✅ API حقيقي
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Haven't got the code yet? ",
                      style: TextStyle(
                        color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isResending ? null : _resend,
                      child: _isResending
                          ? const SizedBox(
                        width: 14, height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: ColorManager.blue),
                      )
                          : const Text(
                        'Resend code',
                        style: TextStyle(
                          color: ColorManager.blue,
                          fontSize: 13, fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}