import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/features/auth/auth_logo.dart';
import 'package:attendo/features/auth/auth_switcher.dart';
import 'package:attendo/features/auth/auth_title.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/widget/forget_password.dart';
import 'package:attendo/ui/register/screen/register_screen.dart';
import 'package:attendo/ui/security/screen/security_screen.dart';
import 'package:flutter/material.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:provider/provider.dart';
import 'package:attendo/core/utils/controller_mixin.dart';
class LoginScreen extends StatefulWidget {
  final bool showLogoutMessage;
  const LoginScreen({super.key, this.showLogoutMessage = false,});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> with ControllerMixin {
  late final emailController    = ctrl();
  late final passwordController = ctrl();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
    });
  }
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  String selectedTab = 'login';
  Future<void> login() async {
    if (formKey.currentState?.validate() != true) return;
    setState(() => isLoading = true);
    try {
      final user = await authRepo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (!mounted) return;
      if (user != null) {
        // ✅ Navigator الأول بدون SnackBar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecurityScreen()
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(customSnack(context.l10n.login_success));
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnack(context.l10n.login_failed, isError: true));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      final errorMsg = e is ApiError ? e.message : context.l10n.unknown_error;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(errorMsg, isError: true),
      );
    }
  }  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark
          ? ColorManager.darkBg
          : ColorManager.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 30,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 36),
                // ── Logo ─────────────────
                AuthLogo(isDark: isDark),
                const SizedBox(height: 28),
                // ── Title ────────────────
                AuthTitle(
                  isDark: isDark,
                  title: 'Welcome Back 👋',
                  subtitle: 'Sign in to access your dashboard',
                ),
                const SizedBox(height: 28),
                // ── Tab switcher ──────────
                AuthTabSwitcher(
                  isLogin: true,
                  isDark: isDark,
                  onChanged: (isLogin) {
                    if (!isLogin) {
                      (
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          )
                      );
                    }
                  },
                ),
                const SizedBox(height: 22),
                // ── Fields ───────────────
                AuthInputField(
                  label: context.l10n.email,
                  controller: emailController,
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
                const SizedBox(height: 14),
                AuthInputField(
                  label: context.l10n.password,
                  controller: passwordController,
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
                const SizedBox(height: 10),
                // ── Forgot password ───────
                _buildForgotPassword(),
                const SizedBox(height: 28),
                // ── Login button ──────────
                AuthButton(
                  label: context.l10n.login,
                  onTap: login,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        child: Text(
        context.l10n.forgot_password_q,
          style: TextStyle(
            color: ColorManager.blue,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}