import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/core/utils/controller_mixin.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/login/widget/password_reset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
// ─────────────────────────────────────────
//  SET NEW PASSWORD SCREEN
//  Password + Confirm → Update → Success
// ─────────────────────────────────────────
class SetPasswordScreen extends StatefulWidget {
  final bool isDark;
  final String resetToken;
  const SetPasswordScreen({super.key, this.isDark = false, required this.resetToken});
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}
class _SetPasswordScreenState extends State<SetPasswordScreen> with ControllerMixin {
  late final _passwordCtrl = ctrl();
  late final _confirmCtrl  = ctrl();
  final _repo = AuthRepo();
  bool _isLoading = false;
  String? _errorMsg;
  Future<void> _resetPassword() async {
    // validation بسيط قبل ما تبعت
    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack("Passwords don't match", isError: true),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _repo.resetPassword(
        resetToken:      widget.resetToken,
        newPassword:     _passwordCtrl.text,
        confirmPassword: _confirmCtrl.text,
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const PasswordSuccessScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack('Password reset successfully!'),
      );
    } on ApiError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(e.message, isError: true),
      );
    } finally {
      setState(() => _isLoading = false);
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
              // ── Back ─────────────────
              BackButton(),
              const SizedBox(height: 32),
              // ── Title ─────────────────
              Text(
                'Set a new password',
                style: TextStyle(
                  color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                  fontSize: 26, fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Create a new password. Ensure it differs from previous ones for security',
                style: TextStyle(
                  color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                  fontSize: 14, height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              // ── Password ──────────────
              AuthInputField(
                label: 'Password',
                controller: _passwordCtrl,
                isDark: isDark,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.shouldnt_be_empty;
                  }
                  if (value.length < 6) {
                    return context.l10n.password_min;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // ── Confirm Password ───────
              AuthInputField(
                label: 'Confirm Password',
                controller: _confirmCtrl,
                isDark: isDark,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.shouldnt_be_empty;
                  }
                  if (value != _passwordCtrl.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              // ── Error message ─────────
              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: ColorManager.red, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _errorMsg!,
                      style: const TextStyle(color: ColorManager.red, fontSize: 12.5),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 28),
              // ── Submit ────────────────
              AuthButton(
                label: 'Update Password',
                isLoading: _isLoading,
                onTap: () {
                  _resetPassword();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
