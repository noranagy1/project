import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/box.dart';
import 'package:attendo/core/reusable_components/submit_complaint.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/ui/QR/screen/qr_screen.dart';
import 'package:attendo/ui/attendence/screen/attendence_screen.dart';
import 'package:attendo/ui/profile_view/screen/profile_header.dart';
import 'package:attendo/ui/profile_view/screen/profile_menu_dialog.dart';
import 'package:flutter/material.dart';
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}
class _SecurityScreenState extends State<SecurityScreen> {
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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
      ),
      child: Scaffold(
        backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Image.asset(
                        'assets/images/gate.png',
                        height: 100,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.more_vert_outlined,
                        size: 45,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                      ProfileHeader(
                        name: user?.name ?? context.l10n.loading,
                        email: user?.email ?? context.l10n.loading,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4),
                            builder: (context) {
                              return ProfileMenuDialog();
                            },
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Color(0xFF9EC8E8),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GridView.count(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.91,
                      children: [
                        Box(
                          imagePath: "assets/images/qr.png",
                          imageColor: Color(0xFF082859),
                          title: context.l10n.attendance,
                          onButtonTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QrScreen(),
                              ));
                          },
                        ),
                        Box(
                          imagePath: "assets/images/report.png",
                          title: context.l10n.attendance_report,
                          onButtonTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceScreen(),
                              ),
                            );}
                        ),
                        Box(
                          imagePath: "assets/images/cam.png",
                          imageColor: Color(0xFF082859),
                          title: context.l10n.camera_control,
                          hasSwitch: true,
                        ),
                        Box(
                          imagePath: "assets/images/gate2.png",
                          imageColor: Color(0xFF082859),
                          title: context.l10n.gate_control,
                          hasSwitch: true,
                        ),
                        Box(
                          imagePath: "assets/images/status.png",
                          title: context.l10n.gate_status,
                        ),
                        Box(
                          imagePath: "assets/images/complaint.png",
                          title: context.l10n.submit_complaint,
                          onButtonTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubmitComplaint(),
                              ),
                              );
                          },
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}