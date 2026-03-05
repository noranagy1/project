import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/ui/login/screen/password_reset.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
class CheckEmail extends StatefulWidget {
  const CheckEmail({super.key});
  @override
  State<CheckEmail> createState() => _CheckEmailState();
}
class _CheckEmailState extends State<CheckEmail> {
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
                    context.l10n.check_email,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    context.l10n.reset_link_sent,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 28),
                  PinCodeTextField(
                    appContext: context,
                    length: 5,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    obscureText: false,
                    onChanged: (value) {},
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(14),
                      fieldHeight: 60,
                      fieldWidth: 55,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      activeColor: Color(0xff5B8DEF),
                      selectedColor: Color(0xff5B8DEF),
                      inactiveColor: Colors.grey.shade300,
                    ),
                    enableActiveFill: true,
                  ),
                  SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: Custombutton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PasswordReset()),
                        );
                      },
                      buttonColor: Color(0xFF3870E4),
                      text:
                      context.l10n.verify_code,
                    ),
                  ),
                  SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  context.l10n.havent_got_email,
                style: TextStyle(
                  color: Color(0xFF6C6C6C),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  context.l10n.resend_email,
                  style: TextStyle(
                    color: Color(0xFF1D61E7),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
                ],
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