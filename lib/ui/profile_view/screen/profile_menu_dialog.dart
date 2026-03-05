import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/profile_view/screen/notification_dialog.dart';
import 'package:attendo/ui/profile_view/screen/profile_edit.dart';
import 'package:attendo/ui/profile_view/screen/setting_dialog.dart';
import 'package:flutter/material.dart';
class ProfileMenuDialog extends StatefulWidget {
  ProfileMenuDialog({super.key});
  @override
  State<ProfileMenuDialog> createState() => _ProfileMenuDialogState();
}
class _ProfileMenuDialogState extends State<ProfileMenuDialog> {
  UserModel? user;
  @override
  void initState() {
    super.initState();
    getProfile();
  }
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
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  Future<void> logout() async {
    try {
      await authRepo.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(showLogoutMessage: true)),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          customSnack('context.l10n.logout_failed: ${e.toString()}'));
    }
  }  late String notificationValue = context.l10n.allow;
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppStyle.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ===== Profile Header =====
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFFDDF4FD).withOpacity(0.2),
                  child: Icon(
                    Icons.person_4_rounded,
                    size: 60,
                    color:Color(0xFFDDF4FD),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? context.l10n.loading,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        user?.email ?? context.l10n.loading,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 10),
            /// ===== My Profile =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person_4_outlined),
              title: Text(context.l10n.my_profile),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEdit(),
                ),
                );
              },
            ),
            /// ===== Settings =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.settings_outlined),
              title: Text(context.l10n.settings),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => SettingsDialog(),
                );
              },
            ),
            /// ===== Notification =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications_none),
              title: Text(context.l10n.notification),
              trailing: Text(
                notificationValue == "Allow" ? context.l10n.allow : context.l10n.mute,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => NotificationDialog(
                    currentValue: notificationValue,
                  ),
                );
                if (result != null) {
                  setState(() {
                    notificationValue = result;
                  });
                }
              },
            ),
            /// ===== Logout =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.logout_rounded),
              title: Text(context.l10n.logout),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}