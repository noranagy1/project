import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/box.dart';
import 'package:attendo/core/reusable_components/labeled_divider.dart';
import 'package:attendo/core/reusable_components/submit_complaint.dart';
import 'package:attendo/core/reusable_components/top_bar.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/ui/QR/screen/qr_screen.dart';
import 'package:attendo/ui/attendence/screen/attendence_screen.dart';
import 'package:attendo/ui/profile_view/screen/profile_header.dart';
import 'package:attendo/ui/profile_view/widget/profile_menu_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});
  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}
class _EmployeeScreenState extends State<EmployeeScreen> {
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
  // ── Section label ──────────────────────
  @override
  Widget build(BuildContext context) {
    final _isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: _isDark ? ColorManager.darkBg : ColorManager.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────
            AppTopBar(),
            // ── Divider ──────────────────
            Divider(
              color: _isDark ? ColorManager.darkDivider : ColorManager.lightDivider,
              thickness: 1, height: 1,
              indent: 20, endIndent: 20,
            ),
            // ── Scrollable ───────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Profile Header ────
                    ProfileHeader(
                      name: user?.name ?? context.l10n.loading,
                      email: user?.email ?? context.l10n.loading,
                      isDark: _isDark,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.4),
                          builder: (context) {
                            return MenuBottomSheet();
                          },
                        );
                        getProfile();
                      },
                    ),
                    const SizedBox(height: 40),
                    // ── Section label ─────
                    LabeledDivider(text: 'الخدمات', isDark: _isDark),
                    // ── Main cards (larger) ─
                    Row(
                      children: [
                        Expanded(
                          child: SmallBox(
                            type: SmallBoxType.attendanceQr,
                            isDark: _isDark,
                            size: SmallBoxSize.large,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QrScreen(),
                                ));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SmallBox(
                            type: SmallBoxType.report,
                            isDark: _isDark,
                            size: SmallBoxSize.large,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportScreen(),
                                ));
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // ── Secondary cards (smaller) ─
                    Row(
                      children: [
                        Expanded(
                          child: SmallBox(
                            type: SmallBoxType.complaint,
                            isDark: _isDark,
                            size: SmallBoxSize.small,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComplaintScreen(),
                                ));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SmallBox(
                            type: SmallBoxType.vehicleReport,
                            isDark: _isDark,
                            size: SmallBoxSize.small,
                            onTap: () {
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}