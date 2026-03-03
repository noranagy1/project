import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/reusable_components/box.dart';
import 'package:attendo/core/reusable_components/submit_complaint.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/ui/QR/screen/qr_screen.dart';
import 'package:attendo/ui/profile_view/screen/profile_header.dart';
import 'package:attendo/ui/profile_view/screen/profile_menu_dialog.dart';
import 'package:flutter/material.dart';
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
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF4894FE),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: ColorManager.gradientEnd.withOpacity(0.9999),
                          blurRadius: 15,
                          spreadRadius: 0,
                          offset: Offset(0, 5)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ProfileHeader(
                        name: user?.name ?? 'Loading...',
                        email: user?.email ?? 'Loading...',
                        onTap: () async {
                         await showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4),
                            builder: (context) {
                              return ProfileMenuDialog();
                            },
                          );
                          getProfile();
                        },
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Color(0x26FFFFFF),
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
                      childAspectRatio: 0.70,
                      children: [
                        Box(
                          imagePath: "assets/images/qr.png",
                          imageColor: Color(0xFF082859),
                          title: "Attendance",
                          subtitle: "Qr code",
                          buttonText: "Generate",
                          onButtonTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QrScreen()),
                            );
                          },
                        ),
                        Box(
                          imagePath: "assets/images/report.png",
                          title: "Attendance report",
                          subtitle: "AR",
                          buttonText: "View",
                          onButtonTap: () {},
                        ),
                        Box(
                          imagePath: "assets/images/status.png",
                          title: "Vehicle report",
                          subtitle: "VR",
                          buttonText: "View",
                          onButtonTap: () {},
                        ),
                        Box(
                          imagePath: "assets/images/complaint.png",
                          title: "Submit a complaint",
                          subtitle: "SC",
                          buttonText: "Make",
                          onButtonTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SubmitComplaint()),
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