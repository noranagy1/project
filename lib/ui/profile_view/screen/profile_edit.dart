import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/ui/profile_view/screen/profile_menu_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}
class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController carNumberController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    carNumberController = TextEditingController();
  }
  @override
  void dispose() {
    /// بستخدمها علشان أحذف الـ Controllers من الذاكرة لما الصفحة تتقفل
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    carNumberController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFECECEC),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      size: 30,
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF1E1E1E),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
              ),
              /// ===== Top Profile Section =====
              Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 20,
                  right: 20,
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                    /// Profile Image
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                              Icons.person_2_outlined, size: 70, color: Color(0xffddf4fd)),
                        ),
                        /// Edit icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white10,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit_sharp,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 15),
                    /// Name & Email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Your name",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "yourname@gmail.com",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ],
                ),
              ),
              Divider(),
              Gap(50),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Customfield(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'should\'t be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        hint: "Name",
                      ),
                      Gap(30),
                      Customfield(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'should\'t be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hint: "Email account",
                      ),
                      Gap(30),
                      Customfield(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'should\'t be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: carNumberController,
                        hint: "Car number",
                      ),
                      const SizedBox(height: 80),
                      /// ===== Save Button =====
                      SizedBox(
                        width: 180,
                        height: 65,
                        child: Custombutton(
                          buttonColor: Color(0xFF3E8DFB),
                          text: "Save Change",
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileMenuDialog(),
                            ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
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
}