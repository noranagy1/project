import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/auth_cubit/signUp_cubit.dart';
import 'package:new_project/Ui/auth_cubit/signUp_state.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/custom/validation.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/routes.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String selectedRole = 'employee';
  bool _isDialogShowing = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignupCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<SignupCubit, SignupState>(
            listener: (context, state) async {
              if (state is LoadingState) {

                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is SuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                UserSession.token = state.authResult.token;
                UserSession.name = state.authResult.user.name;
                UserSession.role = state.authResult.user.role;
                UserSession.email = state.authResult.user.email;
                UserSession.employeeId = state.authResult.user.id;
                await UserSession.save();

                if (selectedRole == 'employee') {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.employee.name,
                    arguments: state.authResult.user.name,
                  );
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.securityScreen.name,
                    arguments: state.authResult.user.name,
                  );
                }
              } else if (state is ErrorState) {

                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    AppFormField(
                      label: AppLocalizations.of(context)!.name,
                      controller: nameController,
                      validator: (text) {
                        if (text?.trim().isEmpty == true)
                          return AppLocalizations.of(context)!.name_required;
                        if (!isValidName(text ?? '')) return AppLocalizations.of(context)!.invalid_name;
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    AppFormField(
                      label: AppLocalizations.of(context)!.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text?.trim().isEmpty == true)
                          return AppLocalizations.of(context)!.email_required;
                        if (!isValidEmail(text ?? '')) return AppLocalizations.of(context)!.invalid_email;
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    AppFormField(
                      label: AppLocalizations.of(context)!.password,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      controller: passwordController,
                      validator: (text) {
                        if (text?.trim().isEmpty == true)
                          return AppLocalizations.of(context)!.password_required;
                        if (!isValidPassword(text ?? ''))
                          return AppLocalizations.of(context)!.invalid_password;
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Role",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.black, fontSize: 16),
                          ),
                          DropdownButton<String>(
                            value: selectedRole,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: const [
                              DropdownMenuItem(
                                value: 'employee',
                                child: Text('employee'),
                              ),
                              DropdownMenuItem(
                                value: 'security',
                                child: Text('security'),
                              ),
                            ],
                            onChanged: (val) =>
                                setState(() => selectedRole = val!),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is LoadingState
                              ? null
                              : () => _createAccount(context),
                          child: state is LoadingState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.sign_up,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isFormValid() {
    return formKey.currentState?.validate() ?? false;
  }

  void _createAccount(BuildContext context) async{
    if (!isFormValid()) return;

    context.read<SignupCubit>().signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: selectedRole,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
