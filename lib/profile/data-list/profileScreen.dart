import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/custom/textFeild.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/profile_cubit.dart';
import 'package:new_project/profile/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isDialogShowing = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getProfile(),
      child: Builder(
        builder: (context) {
          return BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdateLoadingState) {
                _isDialogShowing = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is ProfileUpdateSuccessState) {
                if (_isDialogShowing) {
                  _isDialogShowing = false;
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.data_updated),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ProfileErrorState) {
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
            child: CustomScaffold(
              icons: Icon(Icons.arrow_forward_ios, color: AppColor.royalBlue, size: 30),
              onIconPressed: () => Navigator.pop(context),
              body: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final model = state is ProfileSuccessState
                      ? state.model
                      : state is ProfileUpdateSuccessState
                      ? state.model
                      : null;
                  if (model != null && nameController.text.isEmpty) {
                    nameController.text = model.name;
                    emailController.text = model.email;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DataFile(name: UserSession.name, email: ""),
                        Divider(
                          thickness: 1,
                          color: AppColor.softGray.withOpacity(0.5),
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(height: 12),
                        if (model != null)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.badge_outlined, color: AppColor.royalBlue),
                                SizedBox(width: 8),
                                Text(
                                  '${AppLocalizations.of(context)!.Employee_ID} ${UserSession.employeeId}',
                                  style: TextStyle(color: AppColor.royalBlue),
                                ),
                              ],
                            ),
                          ),

                        // ── Role ──
                        if (model != null)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.work_outline, color: AppColor.royalBlue),
                                SizedBox(width: 8),
                                Text(
                                  'Role: ${model.role}',
                                  style: TextStyle(color: AppColor.royalBlue),
                                ),
                              ],
                            ),
                          ),

                        AppFormField(
                          hintText: AppLocalizations.of(context)!.name,
                          controller: nameController,
                        ),
                        SizedBox(height: 12),

                        AppFormField(
                          hintText: AppLocalizations.of(context)!.email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),

                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is ProfileUpdateLoadingState
                                  ? null
                                  : () {
                                if (nameController.text.trim().isEmpty ||
                                    emailController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context)!.please_enter_email),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                context.read<ProfileCubit>().updateProfile(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.save_change,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}