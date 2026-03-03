import 'package:attendo/core/appStyle.dart';
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
      print('Token in getProfile: $token'); // شوفي الـ token موجود ولا لأ
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
          customSnack('Logout failed: ${e.toString()}'));
    }
  }  String notificationValue = "Allow";
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
                  child: const Icon(
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
                        user?.name ?? 'Loading...',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        user?.email ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 10),
            /// ===== My Profile =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_4_outlined),
              title: const Text("My Profile"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEdit(),
                ),
                );
              },
            ),
            /// ===== Settings =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              trailing: const Icon(Icons.chevron_right),
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
              leading: const Icon(Icons.notifications_none),
              title: const Text("Notification"),
              trailing: Text(
                notificationValue,
                style: const TextStyle(color: Colors.grey),
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
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Log Out"),
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