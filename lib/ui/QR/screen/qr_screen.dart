import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/ui/QR/widget/info_card.dart';
import 'package:attendo/ui/QR/widget/qr_card.dart';
import 'package:attendo/ui/QR/widget/qr_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────
//  QR SCREEN
//  - يعرض الـ QR الخاص بالمستخدم
//  - بعد السكان من الجهاز الخارجي
//    الـ backend يبعت response
//    والشاشة تعرض المسدج تحت الـ QR
// ─────────────────────────────────────────
class QrScreen extends StatefulWidget {
  const QrScreen({
    super.key,
  });
  @override
  State<QrScreen> createState() => _QrScreenState();
}
class _QrScreenState extends State<QrScreen> {
  // ── Scan result state ─────────────────
  // null    = لسه ماسكنش
  // true    = تم تسجيل الحضور
  // false   = فشل التسجيل
  bool? _scanResult;
  bool get _isDark => Provider.of<ThemeProvider>(context).isDark;
  bool _showMessage = false;
  AuthRepo authRepo = AuthRepo();
  UserModel? user;
  late Future<String?> _qrFuture;
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
  void initState() {
    super.initState();
    getProfile();
    _qrFuture = authRepo.getQrData();
    // مثال WebSocket:
    //   _socket.on('scan_result', (data) => _onScanResult(data['success']));
  }
  @override
  void dispose() {
    super.dispose();
  }
  // ── يتنادى من الـ backend response ────
  void _onScanResult(bool success) {
    if (!mounted) return;
    setState(() {
      _scanResult   = success;
      _showMessage  = true;
    });
    // المسدج تختفي بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showMessage = false);
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBg : ColorManager.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 50,
          ),
          child: Column(
            children: [
              // ── Header ─────────────────
              _buildHeader(),
              // ── Divider ────────────────
              Divider(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : const Color(0xFFF1F5F9),
                height: 1,
              ),
              // ── Content ────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      // User info
                      UserInfoCard(isDark: isDark,
                        userName: user?.name ?? context.l10n.loading,
                        userEmail: user?.email ?? context.l10n.loading,),
                      const SizedBox(height: 18),
                      // QR Code card
                      FutureBuilder<String?>(
                        future: _qrFuture,
                        builder: (context, snapshot) {

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text("Failed to load QR");
                          }
                          return QrCard(
                            isDark: isDark,
                            qrData: snapshot.data ?? "",
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Message بعد السكان
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: anim,
                              curve: Curves.easeOut,
                            )),
                            child: child,
                          ),
                        ),
                        child: _showMessage && _scanResult != null
                            ? QrScanMessage(
                          key: ValueKey(_scanResult),
                          isSuccess: _scanResult!,
                          isDark: isDark,
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ── Header ────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _isDark
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: _isDark
                      ? Colors.white.withOpacity(0.08)
                      : ColorManager.lightBorder,
                ),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: _isDark
                    ? ColorManager.darkIconMuted
                    : ColorManager.lightIconMuted,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance QR',
                style: TextStyle(
                  color: _isDark
                      ? ColorManager.darkTextPrimary
                      : ColorManager.lightTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Scan to record your attendance',
                style: TextStyle(
                  color: _isDark
                      ? ColorManager.darkTextSecond
                      : ColorManager.lightTextSecond,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}