import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/custom/validation.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/forgetPassword/forgot_password_cubit.dart';
import 'package:new_project/forgetPassword/forgot_password_state.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/routes.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isDialogShowing = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordLoadingState) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is ForgotPasswordSuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }

                Navigator.pushNamed(
                  context,
                  AppRoutes.checkEmail.name,
                  arguments: emailController.text.trim(),
                );
              } else if (state is ForgotPasswordErrorState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.red,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: AppColor.primary,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.softGray,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios, color: AppColor.black, size: 20),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                         AppLocalizations.of(context)!.forgot_password,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColor.black),
                        ),
                        SizedBox(height: 20),
                        Text(
                         AppLocalizations.of(context)!.please_enter_email,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 20),
                        AppFormField(
                          label: AppLocalizations.of(context)!.email,
                          controller: emailController,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                            if (text?.trim().isEmpty == true) return AppLocalizations.of(context)!.email_required;
                            if (!isValidEmail(text ?? '')) return AppLocalizations.of(context)!.invalid_email;
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is ForgotPasswordLoadingState
                                  ? null
                                  : () {
                                if (formKey.currentState?.validate() == true) {
                                  context.read<ForgotPasswordCubit>().forgotPassword(
                                    email: emailController.text.trim(),
                                  );
                                }
                              },
                              child: state is ForgotPasswordLoadingState
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                AppLocalizations.of(context)!.reset_password,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}