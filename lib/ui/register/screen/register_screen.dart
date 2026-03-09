import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/utils/controller_mixin.dart';
import 'package:attendo/features/auth/auth_logo.dart';
import 'package:attendo/features/auth/auth_switcher.dart';
import 'package:attendo/features/auth/auth_title.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/register/widget/role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> with ControllerMixin {
  late final nameController     = ctrl();
  late final emailController    = ctrl();
  late final passwordController = ctrl();
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); /// علشان أقدر أتحكم في حالة الـ Form وأعمل Validation للبيانات
  @override
  void initState() {
    super.initState();
  }
  UserRole? _selectedRole;
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
        try {
          setState(() => isLoading = true);
          final user = await authRepo.register(
              nameController.text.trim(),
              emailController.text.trim(),
              passwordController.text.trim(),
              _selectedRole?.name ?? '',
          );
          if (!mounted) return;
          print('User: $user');
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(customSnack(context.l10n.registration_success));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(customSnack(context.l10n.registration_failed));
          }
          setState(() => isLoading = false);
        } catch (e) {
          if (!mounted) return;
          setState(() => isLoading = false);
          String errorMsg = context.l10n.error_in_register;
          if (e is ApiError) {
            errorMsg = e.message;
          }
          ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
        }
      }
    }
  @override
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
                  title: 'Create Account ✨',
                  subtitle: 'Sign up to get started with the app',
                ),
                const SizedBox(height: 28),
                // ── Tab switcher ──────────
                AuthTabSwitcher(
                  isLogin: false,
                  isDark: isDark,
                  onChanged: (isLogin) {
                    if (isLogin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 22),
                // ── Fields ───────────────
                AuthInputField(
                  label: context.l10n.name,
                  controller: nameController,
                  isDark: isDark,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return context.l10n.shouldnt_be_empty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthInputField(
                  label: context.l10n.email_account,
                  controller: emailController,
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return context.l10n.shouldnt_be_empty;
                    }
                    /// بيتأكد إن الإيميل مكتوب بطريقة صحيحة باستخدام Regex
                    if (!RegExp(emailRegex).hasMatch(value)) {
                      /// ! دي معناها not يعنى لو الايميل غلط قول كده
                      return context.l10n.invalid_email;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthInputField(
                  label: context.l10n.password,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  isDark: isDark,
                  isPassword: true,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return context.l10n.shouldnt_be_empty;
                    }
                    if(value.length < 8) {
                      return context.l10n.password_min;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                RoleChips(
                  selectedRole: _selectedRole,
                  isDark: isDark,
                  onChanged: (role) => setState(() => _selectedRole = role),
                ),
                const SizedBox(height: 28),
                // ── Sign Up button ────────
                AuthButton(
                  label: 'Create Account',
                  onTap: register,
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
}