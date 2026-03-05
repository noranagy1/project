import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';
class SetPassword extends StatefulWidget {
  const SetPassword({super.key});
  @override
  State<SetPassword> createState() => _SetPasswordState();
}
class _SetPasswordState extends State<SetPassword> {
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }
  @override
  void dispose() { /// بستخدمها علشان أحذف الـ Controllers من الذاكرة لما الصفحة تتقفل
    super.dispose();
    passwordController.dispose();
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
                    context.l10n.set_new_password,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Gap(15),
                  Text(
                    context.l10n.set_new_password_msg,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Gap(40),
                  SizedBox(
                    width: double.infinity,
                    child: Customfield(
                      label: context.l10n.password,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return context.l10n.shouldnt_be_empty;
                        }
                        /// بيتأكد إن الإيميل مكتوب بطريقة صحيحة باستخدام Regex
                        if (!RegExp(emailRegex).hasMatch(value)) { /// لو القيمة اللي المستخدم كتبها مش بتطابق شكل الإيميل الصح
                          /// ! دي معناها not يعنى لو الايميل غلط قول كده
                          return context.l10n.invalid_email;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordController,
                      isObscured: true,
                    ),
                  ),
                  Gap(25),
                  SizedBox(
                    width: double.infinity,
                    child: Customfield(
                      label: context.l10n.confirm_password,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return context.l10n.shouldnt_be_empty;
                        }
                        /// بيتأكد إن الإيميل مكتوب بطريقة صحيحة باستخدام Regex
                        if (!RegExp(emailRegex).hasMatch(value)) { /// لو القيمة اللي المستخدم كتبها مش بتطابق شكل الإيميل الصح
                          /// ! دي معناها not يعنى لو الايميل غلط قول كده
                          return context.l10n.invalid_email;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordController,
                      isObscured: true,
                    ),
                  ),
                  Gap(25),
                  SizedBox(
                    width: double.infinity,
                    child: Custombutton(
                      onPressed: () {},
                      buttonColor: Color(0xFF3870E4),
                      text:
                      context.l10n.update_password,
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
