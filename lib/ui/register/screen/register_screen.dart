import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/security/screen/security_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); /// علشان أقدر أتحكم في حالة الـ Form وأعمل Validation للبيانات
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
  @override
  void dispose() { /// بستخدمها علشان أحذف الـ Controllers من الذاكرة لما الصفحة تتقفل
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  String? selectedRole;
  bool isLoading = false;
  late String selectedTab = context.l10n.register;
  AuthRepo authRepo = AuthRepo();
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
        try {
          setState(() => isLoading = true);
          final user = await authRepo.register(
              nameController.text.trim(), emailController.text.trim(),
              passwordController.text.trim(), selectedRole!.trim());
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(customSnack(context.l10n.registration_success));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(customSnack(context.l10n.registration_failed));
          }
          setState(() => isLoading = false);
        } catch (e) {
          setState(() => isLoading = false);
          String errorMsg = context.l10n.error_in_register;
          if (e is ApiError) {
            errorMsg = e.message;
          }
          ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
        }
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 60,
          ),
          child: SingleChildScrollView(
            child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap(20),
                      Image.asset(
                        'assets/images/gate.png',
                        height: 200,
                        fit: BoxFit.fitHeight,
                      ),
                      Text(
                        context.l10n.get_started,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gap(8),
                      Text(
                        context.l10n.create_or_login,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey
                        ),
                      ),
                      Gap(20),
                      CupertinoSlidingSegmentedControl<String>(
                        groupValue: selectedTab,
                        children: {
                          context.l10n.login: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(context.l10n.log_in),
                          ),
                          context.l10n.register: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(context.l10n.sign_up),
                          ),
                        },
                        onValueChanged: (value) {
                          if (value == context.l10n.login) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          } else {
                            setState(() => selectedTab = value!);
                          }
                        },
                      ),
                      Gap(30),
                      Customfield(
                        /// الـ validator بيتأكد إن المستخدم مايسيبش الحقل فاضى
                        /// لو الحقل فاضي بيظهر رسالة خطأ، ولو المستخدم كتب بيانات صح بيرجع null وبيسمح للفورم يكمل
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return context.l10n.shouldnt_be_empty;
                          }
                          return null;
                        },
                        label: context.l10n.name,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                      ),
                      Gap(16),
                      Customfield(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return context.l10n.shouldnt_be_empty;
                          }
                          /// بيتأكد إن الإيميل مكتوب بطريقة صحيحة باستخدام Regex
                          if (!RegExp(emailRegex).hasMatch(value)) {
                       /// ! دي معناها not يعنى لو الايميل غلط قول كده
                            return context.l10n.invalid_email;
                          }
                          return null;
                        },
                        label: context.l10n.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Gap(16),
                      Customfield(
                        /// الـ validator هنا بيتأكد إن المستخدم مايسيبش الباسورد فاضي، وكمان بيتأكد إن الباسورد يكون 8 حروف على الأقل
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return context.l10n.shouldnt_be_empty;
                          }
                          if(value.length < 8) {
                            return context.l10n.password_min;
                          }
                          return null;
                        },
                        label: context.l10n.password,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        isObscured: true,
                      ),
                      Gap(16),
                      DropdownButton(
                        dropdownColor: AppStyle.lightTheme.scaffoldBackgroundColor,
                        isExpanded: true,
                          value: selectedRole,
                          hint: Text(context.l10n.select_role),
                          items: [context.l10n.employee, context.l10n.security].map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                          },
                      ),
                      Gap(16),
                      /// Registe button
                      isLoading
                          ? CupertinoActivityIndicator()
                          : SizedBox(
                        width: double.infinity,
                        child: Custombutton(
                          text: context.l10n.register,
                          buttonColor: Color(0xFF3870E4),
                          /// لما المستخدم يضغط على زرار التسجيل، التطبيق بيتأكد الأول إن كل البيانات اللي في الفورم صح باستخدام validate
                           /// معني validate() انه راح شغل كله ال validators اللى فى form عشان يتأكد ان البيانات صح
                          onPressed: () {
                            register();
                          },
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