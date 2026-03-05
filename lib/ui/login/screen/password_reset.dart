import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/ui/login/screen/set_password.dart';
import 'package:flutter/material.dart';
class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});
  @override
  State<PasswordReset> createState() => _PasswordResetState();
}
class _PasswordResetState extends State<PasswordReset> {
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  SizedBox(height: 30),
                  Text(
                    context.l10n.password_reset,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    context.l10n.password_reset_msg,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: Custombutton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetPassword()),
                        );
                      },
                      buttonColor: Color(0xFF3870E4),
                      text:
                      context.l10n.confirm,
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
