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
class SetPasswordScreen extends StatefulWidget {
  final String resetToken;
  const SetPasswordScreen({super.key, required this.resetToken});
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}
class _SetPasswordScreenState extends State<SetPasswordScreen> with ControllerMixin {
  late final _passwordCtrl = ctrl();
  late final _confirmCtrl  = ctrl();
  final _repo = AuthRepo();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    // ── Validation ────────────────────
    if (_passwordCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(context.l10n.password_min, isError: true),
      );
      return;
    }
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
      if (!mounted) return;// ✅ قبل أي Navigator أو SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
          customSnack("Password updated"),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PasswordSuccessScreen()),
      );
      // ✅ SnackBar بعد الـ navigate مش هيبان — شيلناه
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
                  if (value == null || value.isEmpty) return context.l10n.shouldnt_be_empty;
                  if (value.length < 6) return context.l10n.password_min;
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
                  if (value == null || value.isEmpty) return context.l10n.shouldnt_be_empty;
                  if (value != _passwordCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              AuthButton(
                label: 'Update Password',
                isLoading: _isLoading,
                onTap: _resetPassword, // ✅ API حقيقي
              ),
            ],
          ),
        ),
      ),
    );
  }
}