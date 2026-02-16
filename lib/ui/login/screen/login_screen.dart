import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/register/screen/register_screen.dart';
import 'package:attendo/ui/views/profileView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendo/core/constants.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:gap/gap.dart';
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
  void dispose() { /// بستخدمها علشان أحذف الـ Controllers من الذاكرة لما الصفحة تتقفل
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  Future<void> login() async {
    if(formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final user = await authRepo.login(emailController.text.trim(), passwordController.text.trim()); /// فى طريقه toJson
        if(user != null) { /// لو user رجع بdata
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute( /// روح بقى للشاشة اللى انت عايزها
            builder: (context) => Profileview(),
          ), (route) => false
          );
          ScaffoldMessenger.of(context).showSnackBar(customSnack('login successfully'));
        }
        setState(() => isLoading = false);
      } catch (e) {
        setState(() => isLoading = false);
        String errorMsg = 'unhandled error in login';
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
      appBar: AppBar(
        backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 100,
            horizontal: 50,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(30),
                Customfield(
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
                  hint: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xFF6C6C6C),
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                Gap(20),
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
                  hint: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF6C6C6C),
                  ),
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  isObscured: true,
                ),
                Gap(1),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF6C6C6C),
                          ),
                        ),
                                      ),
                    ),
                Gap(10),
                /// login button
                isLoading
                    ? CupertinoActivityIndicator(color: Colors.white)
                    : SizedBox(
                  width: double.infinity,
                  child: Custombutton(
                    text: 'Login',
                    /// لما المستخدم يضغط على زرار التسجيل، التطبيق بيتأكد الأول إن كل البيانات اللي في الفورم صح باستخدام validate
                    /// معني validate() انه راح شغل كله ال validators اللى فى form عشان يتأكد ان البيانات صح
                    onPressed: login,
                  ),
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Don\'t have an account?',
                      style: TextStyle(
                        color: Color(0xFF6C6C6C),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ));
                      },
                      child: Text(
                        'Sign Up',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}