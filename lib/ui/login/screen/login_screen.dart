import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/employee/screen/employee_screen.dart';
import 'package:attendo/ui/login/screen/forget_password.dart';
import 'package:attendo/ui/register/screen/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  String selectedTab = 'login';
  Future<void> login() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    setState(() => isLoading = true);
    try {
      final user = await authRepo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (!mounted) return;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(customSnack('Login success'));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeScreen()),
        );
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnack('Login failed'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      final errorMsg =
      e is ApiError ? e.message : "An unknown error occurred.";
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
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
                    'Create an account or log in to explore\nabout our app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
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
                      if (value == 'register') {
                        context.go('/register');
                      } else {
                        setState(() => selectedTab = value!);
                      }
                    },
                  ),
                  Gap(30),
                  Customfield(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "shouldn't be empty";
                      }
                      if (!RegExp(emailRegex).hasMatch(value)) {
                        return "invalid email";
                      }
                      return null;
                    },
                    label: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Gap(25),
                  Customfield(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "shouldn't be empty";
                      }
                      if (value.length < 6) {
                        return "password should be at least 8 characters";
                      }
                      return null;
                    },
                    label: 'Password',
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    isObscured: true,
                  ),
                  Gap(1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassword()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF1D61E7),
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? CupertinoActivityIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3870E4),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 17,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  width: 1,
                                  color: Color(0xFF3870E4),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmployeeScreen()),
                              );
                              login();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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