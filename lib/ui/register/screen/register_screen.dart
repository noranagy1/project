import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
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
  String selectedTab = 'register';
  AuthRepo authRepo = AuthRepo();
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
        try {
          setState(() => isLoading = true);
          final user = await authRepo.register(
              nameController.text.trim(), emailController.text.trim(),
              passwordController.text.trim(), selectedRole!.trim());
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(customSnack('Registration success'));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(customSnack('Registration failed'));
          }
          setState(() => isLoading = false);
        } catch (e) {
          setState(() => isLoading = false);
          String errorMsg = 'error in register';
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
                        'Get Started now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gap(8),
                      Text(
                        'Create an account or log in to explore \n about our app',
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
                          'login': Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Log In'),
                          ),
                          'register': Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Sign Up'),
                          ),
                        },
                        onValueChanged: (value) {
                          if (value == 'login') {
                            context.go('/login');
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
                            return 'should\'t be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        controller: nameController,
                        keyboardType: TextInputType.name,
                      ),
                      Gap(16),
                      Customfield(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'should\'t be empty';
                          }
                          /// بيتأكد إن الإيميل مكتوب بطريقة صحيحة باستخدام Regex
                          if (!RegExp(emailRegex).hasMatch(value)) {
                       /// ! دي معناها not يعنى لو الايميل غلط قول كده
                            return 'invalid email';
                          }
                          return null;
                        },
                        label: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Gap(16),
                      Customfield(
                        /// الـ validator هنا بيتأكد إن المستخدم مايسيبش الباسورد فاضي، وكمان بيتأكد إن الباسورد يكون 8 حروف على الأقل
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'should\'t be empty';
                          }
                          if(value.length < 8) {
                            return 'password should\'be at least 8 characters';
                          }
                          return null;
                        },
                        label: 'Password',
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        isObscured: true,
                      ),
                      Gap(16),
                      DropdownButton(
                        dropdownColor: AppStyle.lightTheme.scaffoldBackgroundColor,
                        isExpanded: true,
                          value: selectedRole,
                          hint: Text('Select Role'),
                          items: ['employee', 'security'].map((role) {
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
                          text: 'Register',
                          buttonColor: Color(0xFF3870E4),
                          /// لما المستخدم يضغط على زرار التسجيل، التطبيق بيتأكد الأول إن كل البيانات اللي في الفورم صح باستخدام validate
                           /// معني validate() انه راح شغل كله ال validators اللى فى form عشان يتأكد ان البيانات صح
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SecurityScreen()),
                            );
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