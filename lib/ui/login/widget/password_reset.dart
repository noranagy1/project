import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────
//  PASSWORD SUCCESS SCREEN
//  ✅ Password reset successfully
// ─────────────────────────────────────────
class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({super.key, });
  @override
  State<PasswordSuccessScreen> createState() => _PasswordSuccessScreenState();
}
class _PasswordSuccessScreenState extends State<PasswordSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut);
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }
  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }
  void _confirm() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBg : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Back ─────────────────
              Padding(
                padding: const EdgeInsets.only(right: 350),
                child: BackButton(),
              ),
              // ── Center content ────────
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Success icon ───────
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.emerald.withOpacity(
                                isDark ? 0.12 : 0.08),
                            border: Border.all(
                              color: ColorManager.emerald.withOpacity(0.25),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.emerald.withOpacity(0.08),
                                blurRadius: 0,
                                spreadRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_circle_outline_rounded,
                            color: ColorManager.emerald,
                            size: 44,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // ── Title ──────────────
                      Text(
                        'Password reset',
                        style: TextStyle(
                          color: isDark
                              ? ColorManager.darkTextPrimary
                              : const Color(0xFF0F172A),
                          fontSize: 26, fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your password has been successfully reset.\nClick confirm to set a new password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? ColorManager.darkTextSecond
                              : ColorManager.lightTextSecond,
                          fontSize: 14, height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Confirm button ────────
              AuthButton(
                label: 'Confirm',
                onTap: _confirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}