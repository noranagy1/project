import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/core/utils/controller_mixin.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/widget/check_email.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with ControllerMixin {
  late final emailCtrl = ctrl();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _repo = AuthRepo();
  Future<void> _sendCode() async {
    if (formKey.currentState?.validate() != true) return;
    setState(() => _isLoading = true);
    try {
      await _repo.forgotPassword(emailCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack("Reset link sent"),
      );      Navigator.push(context, MaterialPageRoute(
        builder: (_) => OtpVerifyScreen(email: emailCtrl.text.trim()),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBg : ColorManager.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                const SizedBox(height: 32),
                Text(
                  'Forgot password',
                  style: TextStyle(
                    color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                    fontSize: 26, fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please enter your email to reset the password',
                  style: TextStyle(
                    color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                    fontSize: 14, height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                AuthInputField(
                  label: 'Email',
                  controller: emailCtrl,
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.shouldnt_be_empty;
                    }
                    if (!RegExp(emailRegex).hasMatch(value)) {
                      return context.l10n.invalid_email;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                AuthButton(
                  label: 'Reset Password',
                  isLoading: _isLoading,
                  onTap: _sendCode, // ✅ API حقيقي + validation
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}