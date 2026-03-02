import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/ui/login/screen/check_email.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}
class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController emailController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }
  @override
  void dispose() { /// بستخدمها علشان أحذف الـ Controllers من الذاكرة لما الصفحة تتقفل
    super.dispose();
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
          child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 30,
                ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
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
                                  Gap(30),
                                  Text(
                                          'Forgot password',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                  Gap(15),
                                  Text(
                                        'Please enter your email to reset the password',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                  Gap(40),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Customfield(
                                            label: 'Your Email',
                                            validator: (value) {
                                              if(value == null || value.isEmpty) {
                                                return 'should\'t be empty';
                                              }
                                              /// بيتأكد إن الإيميل مكتوب بطريقة صحيحة باستخدام Regex
                                              if (!RegExp(emailRegex).hasMatch(value)) { /// لو القيمة اللي المستخدم كتبها مش بتطابق شكل الإيميل الصح
                                                /// ! دي معناها not يعنى لو الايميل غلط قول كده
                                                return 'invalid email';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            controller: emailController,
                                        ),
                                  ),
                                  Gap(25),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Custombutton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => CheckEmail()),
                                              );
                                            },
                                      buttonColor: Color(0xFF3870E4),
                                            text:
                                            'Reset Password',
                                        ),
                                  ),
                                          ],
                                              ),
                            ),
                          ),
          ),
        ),
    );
  }
}