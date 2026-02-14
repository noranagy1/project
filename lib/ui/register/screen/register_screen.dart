import 'package:attendo/core/constants.dart';
import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/reusable_components/customSnackBar.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  Future<void> register() async {
    if(!formKey.currentState!.validate()) {
      try {
        setState(() => isLoading = true);
        final user = await authRepo.register(nameController.text, emailController.text, passwordController.text);
        if(user != null) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
        }
        setState(() => isLoading = false);
      }catch(e){
        setState(() => isLoading = false);
        String errorMsg = 'error in register';
        if(e is ApiError) {
          errorMsg = e.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                    Gap(20),
                    Customfield(
                      /// الـ validator بيتأكد إن المستخدم مايسيبش الحقل فاضى
                      /// لو الحقل فاضي بيظهر رسالة خطأ، ولو المستخدم كتب بيانات صح بيرجع null وبيسمح للفورم يكمل
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'should\'t be empty';
                        }
                        return null;
                      },
                      hint: 'Name',
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF6C6C6C),
                      ),
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
                      hint: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF6C6C6C),
                      ),
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
                      hint: 'Password',
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF6C6C6C),
                      ),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      isObscured: true,
                    ),
                    Gap(16),
                    DropdownButtonFormField(
                      hint: Text(
                          'Select Role',
                              style: TextStyle(
                          color: Color(0xFF6C6C6C),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Employee',
                          child: Text(
                              'Employee'),
                        ),
                        DropdownMenuItem(
                          value: 'Security',
                          child: Text('Security'),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                    Gap(16),
                    isLoading
                        ? CupertinoActivityIndicator()
                        : Container(
                      width: double.infinity,
                      child: Custombutton(
                        text: 'Create Account',
                        /// لما المستخدم يضغط على زرار التسجيل، التطبيق بيتأكد الأول إن كل البيانات اللي في الفورم صح باستخدام validate
                         /// معني validate() انه راح شغل كله ال validators اللى فى form عشان يتأكد ان البيانات صح
                        onPressed: () {
                          if(formKey.currentState!.validate()) {
                            /// ! null check
                            register();
                          }
                        },
                      ),
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'already have an account?',
                          style: TextStyle(
                            color: Color(0xFF6C6C6C),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                          },
                          child: Text(
                              'Login',
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