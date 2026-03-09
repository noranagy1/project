import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/box.dart';
import 'package:attendo/core/reusable_components/labeled_divider.dart';
import 'package:attendo/core/reusable_components/section_label.dart';
import 'package:attendo/core/reusable_components/submit_complaint.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/core/utils/app_icons.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/ui/QR/screen/qr_screen.dart';
import 'package:attendo/ui/attendence/screen/attendence_screen.dart';
import 'package:attendo/ui/profile_view/screen/profile_header.dart';
import 'package:attendo/ui/profile_view/widget/profile_menu_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}
class _SecurityScreenState extends State<SecurityScreen> {
  @override
  void initState() {
    super.initState();
    getProfile();
}
  AuthRepo authRepo = AuthRepo();
  UserModel? user;
  Future<void> getProfile() async {
    try {
      final token = await PrefHelper.getToken();
      print('Token in getProfile: $token');
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
    return Scaffold(
      backgroundColor: isDark
          ? ColorManager.darkBg
          : ColorManager.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 40, 25, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Building icon (left)
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorManager.darkCameraIconBg
                          : ColorManager.lightTopIconBg,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: isDark
                            ? const Color(0x263B82F6)
                            : ColorManager.lightTopIconBorder,
                      ),
                    ),
                    child: const Icon(
                      AppIcons.building,
                      color: ColorManager.blue,
                      size: 20,
                    ),
                  ),
                  // More vert (right)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => MenuBottomSheet(),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? ColorManager.darkProfileBg
                            : ColorManager.lightMenuBg,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: isDark
                              ? ColorManager.darkBorder
                              : ColorManager.lightBorder,
                        ),
                      ),
                      child: Icon(
                        AppIcons.moreVert,
                        color: isDark
                            ? ColorManager.darkIconMuted
                            : ColorManager.lightIconMuted,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Divider ──────────────────
            Divider(
              color: isDark
                  ? ColorManager.darkDivider
                  : ColorManager.lightDivider,
              thickness: 1,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            // ── Scrollable content ────────
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context)
                    .copyWith(overscroll: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(25, 14, 25, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile Header ──
                      ProfileHeader(
                        name: user?.name ?? context.l10n.loading,
                        email: user?.email ?? context.l10n.loading,
                        isDark: isDark,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4),
                            builder: (context) {
                              return MenuBottomSheet();
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 35),
                      // ── Section: التحكم ─
                      SectionLabel(text: 'التحكم', isDark: isDark),
                      // ── Divider ─────────
                      SizedBox(
                        height: 20,
                      ),
                      // ── Divider ─────────
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          MainBox(
                            type: MainBoxType.camera,
                            isDark: isDark,
                          ),
                          MainBox(
                            type: MainBoxType.gate,
                            isDark: isDark,
                          ),
                        ],
                      ),
                      // ── Divider ─────────
                      SizedBox(
                        height: 20,
                      ),
                      LabeledDivider(text: 'الخدمات', isDark: isDark),
                      // ── Section: الخدمات ─
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SmallBox(
                            type: SmallBoxType.attendanceQr,
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QrScreen(),
                                ));
                            },
                          ),
                          SmallBox(
                            type: SmallBoxType.report,
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportScreen(),
                                ));
                            },
                          ),
                          SmallBox(
                            type: SmallBoxType.complaint,
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComplaintScreen(),
                                ));
                            },
                          ),
                          SmallBox(
                            type: SmallBoxType.gateStatus,
                            isDark: isDark,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}