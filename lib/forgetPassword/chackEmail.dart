import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/forgetPassword/verify_otp_cubit.dart';
import 'package:new_project/forgetPassword/verify_otp_state.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/routes.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({super.key});

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final List<TextEditingController> otpControllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());
  bool _isDialogShowing = false;

  String get otp => otpControllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocProvider(
      create: (_) => getIt<VerifyOtpCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) {
              if (state is VerifyOtpLoading) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is VerifyOtpSuccess) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                Navigator.pushNamed(
                  context,
                  AppRoutes.newPassword.name,
                  arguments: {'token': state.token},
                );
              } else if (state is VerifyOtpError) {
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 32,
                  ),
                  child: IntrinsicHeight(
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
                              icon: Icon(Icons.arrow_back_ios,
                                  color: AppColor.black, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.check_email,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColor.black),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.send_code,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final boxSize = (constraints.maxWidth - (4 * 12)) / 5;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (index) {
                                return Container(
                                  width: boxSize,
                                  height: boxSize,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColor.softGray),
                                  ),
                                  child: TextField(
                                    controller: otpControllers[index],
                                    focusNode: focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.black,
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 4) {
                                        focusNodes[index + 1].requestFocus();
                                      }
                                      if (value.isEmpty && index > 0) {
                                        focusNodes[index - 1].requestFocus();
                                      }
                                    },
                                  ),
                                );
                              }),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is VerifyOtpLoading
                                  ? null
                                  : () {
                                if (otp.length < 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!.enter_code),
                                      backgroundColor: AppColor.red,
                                    ),
                                  );
                                  return;
                                }
                                context.read<VerifyOtpCubit>().verifyOtp(
                                  email: email,
                                  otp: otp,
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.verify_code,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.havent_got_email,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<VerifyOtpCubit>().resendOtp(email: email);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.resend_email,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColor.royalBlue,
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
        },
      ),
    );
  }
}