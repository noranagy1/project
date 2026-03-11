import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/profile_view/widget/notification_dialog.dart';
import 'package:attendo/ui/profile_view/widget/profile_edit.dart';
import 'package:attendo/ui/profile_view/widget/setting_dialog.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────
//  MENU BOTTOM SHEET
//  بتتفتح من الـ 3 نقاط في home_screen
// ─────────────────────────────────────────

// ── بتفتحي المنيو من أي شاشة كده ─────────
void showMenuBottomSheet(BuildContext context, {required bool isDark}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => MenuBottomSheet(),
  );
}
// ─────────────────────────────────────────
class MenuBottomSheet extends StatefulWidget {
  MenuBottomSheet({super.key, });
  @override
  State<MenuBottomSheet> createState() => _MenuBottomSheetState();
}
class _MenuBottomSheetState extends State<MenuBottomSheet> {
  AuthRepo authRepo = AuthRepo();
  UserModel? user;
  @override
  void initState() {
    super.initState();
    getProfile();
  }
  Future<void> getProfile() async {
    try {
      final token = await PrefHelper.getToken();
      print('Token in getProfile: $token'); // شوفي الـ token موجود ولا لأ
      final data = await authRepo.getProfile();
      if (!mounted) return;
      setState(() => user = data);
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 40,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : ColorManager.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // ── User info ─────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile screen
              },
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDark
                          ? ColorManager.blue.withOpacity(0.12)
                          : const Color(0xFFEFF6FF),
                      border: Border.all(
                        color: isDark
                            ? ColorManager.blue.withOpacity(0.2)
                            : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: ColorManager.blue, size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name + email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? context.l10n.loading, // TODO: استبدل بالاسم الحقيقي
                          style: TextStyle(
                            color: isDark
                                ? ColorManager.darkTextPrimary
                                : const Color(0xFF1E293B),
                            fontSize: 14, fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? context.l10n.loading, // TODO: استبدل بالإيميل الحقيقي
                          style: TextStyle(
                            color: isDark
                                ? ColorManager.darkTextSecond
                                : ColorManager.lightTextSecond,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // ── Divider ───────────────
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFF1F5F9),
            thickness: 1, height: 1,
            indent: 20, endIndent: 20,
          ),
          // ── Menu items ────────────
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _MenuItem(
                  icon: Icons.person_outline_rounded,
                  label: context.l10n.profile,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: context.l10n.settings,
                  isDark: isDark,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => SettingsDialog(),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: context.l10n.notification,
                  isDark: isDark,
                  trailing: Text(
                    context.l10n.allow,
                    style: TextStyle(
                      color: ColorManager.blue,
                      fontSize: 12, fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => NotificationDialog(currentValue: context.l10n.allow),
                  ),
                ),
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: context.l10n.logout,
                  isDark: isDark,
                  isDestructive: true,
                  onTap: () async {
                    try {
                      await authRepo.logout();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnack(context.l10n.logout_successfully),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(showLogoutMessage: true),
                        ),
                            (route) => false,
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnack(context.l10n.logout_failed, isError: true),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // ── Bottom safe area ──────
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  MENU ITEM
// ─────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool isDestructive;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? ColorManager.red
        : (isDark ? ColorManager.darkTextPrimary : const Color(0xFF1E293B));

    final iconBg = isDestructive
        ? ColorManager.red.withOpacity(0.08)
        : (isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 20),
            ),

            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14.5, fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Trailing (chevron or badge)
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? ColorManager.darkTextSecond
                      : ColorManager.lightTextSecond,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}