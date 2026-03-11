import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/core/utils/controller_mixin.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
// ─────────────────────────────────────────
//  UPDATE PROFILE SCREEN
//  Name + Email + Car Number → Save Changes
// ─────────────────────────────────────────
class UpdateProfileScreen extends StatefulWidget {
  final bool isDark;
  const UpdateProfileScreen({super.key, this.isDark = false});
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}
class _UpdateProfileScreenState extends State<UpdateProfileScreen> with ControllerMixin {
  late final _nameCtrl   = ctrl();
  late final _emailCtrl  = ctrl();
  late final _carNumCtrl = ctrl();
  bool _isLoading      = false;
  final _repo          = AuthRepo();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await _repo.getProfile();
      if (user != null && mounted) {
        _nameCtrl.text  = user.name;
        _emailCtrl.text = user.email;
        setState(() {});
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _carNumCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await _repo.updateProfile(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _carNumCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          customSnack("Profile updated"),
      );
        Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: ColorManager.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBg : ColorManager.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back button ───────────
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFFF1F5F9),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : ColorManager.lightBorder,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: isDark
                        ? ColorManager.darkTextSecond
                        : const Color(0xFF64748B),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // ── Avatar + name ─────────
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Avatar
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [ColorManager.blue, ColorManager.blueDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.blue.withOpacity(0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
                      ),
                      // Edit badge
                      Positioned(
                        bottom: -4, right: -4,
                        child: Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.blue,
                            border: Border.all(
                              color: isDark ? ColorManager.darkBg : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameCtrl.text.isNotEmpty ? _nameCtrl.text : '...',
                        style: TextStyle(
                          color: isDark
                              ? ColorManager.darkTextPrimary
                              : const Color(0xFF1E293B),
                          fontSize: 16, fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _emailCtrl.text.isNotEmpty ? _emailCtrl.text : '...',
                        style: TextStyle(
                          color: isDark
                              ? ColorManager.darkTextSecond
                              : ColorManager.lightTextSecond,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // ── Divider ───────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : const Color(0xFFF1F5F9),
                  thickness: 1, height: 1,
                ),
              ),
              // ── Form ──────────────────
              AuthInputField(
                label: context.l10n.name,
                controller: _nameCtrl,
                isDark: isDark,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return context.l10n.shouldnt_be_empty;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthInputField(
                label: context.l10n.email_account,
                controller: _emailCtrl,
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
              const SizedBox(height: 16),
              AuthInputField(
                label: context.l10n.car_number,
                controller: _carNumCtrl,
                isDark: isDark,
                validator: (String? p1) {  },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              // ── Save button ───────────
              AuthButton(
                label: context.l10n.save_changes,
                isLoading: _isLoading,
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}