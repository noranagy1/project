import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/statusService/gateService/device_cubit.dart';
import 'package:new_project/Ui/statusService/gateService/device_service.dart';
import 'package:new_project/Ui/statusService/gateService/device_state.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';

bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  bool get gateOn => UserSession.gateStatus.value;
  bool get cameraOn => UserSession.cameraStatus.value;

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode(context);

    return BlocProvider(
      create: (_) => DeviceCubit(
        DeviceService(
          baseUrl: 'https://smart-system-attendance-production-d4bd.up.railway.app',
          token: UserSession.token,
        ),
      ),
      child: BlocConsumer<DeviceCubit, DeviceState>(
        listener: (context, state) {
          if (state is DeviceCommandDone) {
            if (state.type == 'statusService') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(gateOn ? AppLocalizations.of(context)!.gate_open : AppLocalizations.of(context)!.gate_close),
                  backgroundColor: AppColor.green,
                ),
              );
            } else if (state.type == 'camera') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cameraOn ? AppLocalizations.of(context)!.camera_open : AppLocalizations.of(context)!.camera_close),
                  backgroundColor: AppColor.green,
                ),
              );
            }
          } else if (state is DeviceError) {
            if (state.type == 'gate') {
              UserSession.gateStatus.value = !gateOn;
            } else {
              UserSession.cameraStatus.value = !cameraOn;
            }
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message}'),
                backgroundColor: AppColor.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DeviceLoading || state is DeviceCommandSent;

          return CustomScaffold(
            image: AppImage.Logo,
            icons: Icon(Icons.arrow_forward_ios, color: AppColor.royalBlue, size: 30),
            onIconPressed: () => Navigator.pop(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DataFile(name: UserSession.name, email: ''),
                  const SizedBox(height: 20),
              
                  _DeviceCard(
                    dark: dark,
              
                    backgroundColor: dark ? AppColor.darkBackground : AppColor.white,
                    borderColor: dark
                        ? AppColor.movBlue.withValues(alpha: 0.8)
                        : AppColor.softBlue,
                    title: AppLocalizations.of(context)!.gate_control,
                    titleColor: dark ? AppColor.white : AppColor.black,
                    lines: [
                      _InfoLine(label: AppLocalizations.of(context)!.gate, value: AppLocalizations.of(context)!.d1, dark: dark),
                      _InfoLine(label:AppLocalizations.of(context)!.status, value: gateOn ? AppLocalizations.of(context)!.open_gate : AppLocalizations.of(context)!.close_gate, dark: dark),
                      _InfoLine(label: AppLocalizations.of(context)!.connection, value: AppLocalizations.of(context)!.connected, dark: dark),
                    ],
                    isLoading: isLoading,
                    isOn: gateOn,
                    onToggle: () {
                      final newState = !gateOn;
                      UserSession.gateStatus.value = newState;
                      setState(() {});
                      context.read<DeviceCubit>().sendCommand(
                        newState ? AppLocalizations.of(context)!.open_gate : AppLocalizations.of(context)!.close_gate,
                      );
                    },
                    image: AppImage.darkGate,
                  ),
              
                  const SizedBox(height: 20),
                  _DeviceCard(
                    dark: dark,
                    backgroundColor: dark ? AppColor.darkBackground : AppColor.royalBlue,
                    borderColor: dark
                        ? AppColor.movBlue.withValues(alpha: 0.8)
                        : Colors.transparent,
                    title: AppLocalizations.of(context)!.control_of_camera,
                    titleColor: AppColor.white,
                    lines: [
                      _InfoLine(label: AppLocalizations.of(context)!.camera, value: AppLocalizations.of(context)!.face_id, dark: dark, forceWhite: !dark),
                      _InfoLine(label:AppLocalizations.of(context)!.status, value: cameraOn ?AppLocalizations.of(context)!.open_camera : AppLocalizations.of(context)!.close_camera, dark: dark, forceWhite: !dark),
                      _InfoLine(label: AppLocalizations.of(context)!.connection, value: AppLocalizations.of(context)!.connected, dark: dark, forceWhite: !dark),
                    ],
                    isLoading: isLoading,
                    isOn: cameraOn,
                    onToggle: () {
                      final newState = !cameraOn;
                      UserSession.cameraStatus.value = newState;
                      setState(() {});
                      context.read<DeviceCubit>().sendCameraCommand(
                        newState ? AppLocalizations.of(context)!.open_camera : AppLocalizations.of(context)!.close_camera,
                      );
                    },
                    image: AppImage.camera,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class _DeviceCard extends StatelessWidget {
  final bool dark;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final Color titleColor;
  final List<_InfoLine> lines;
  final bool isLoading;
  final bool isOn;
  final VoidCallback onToggle;
  final String image;

  const _DeviceCard({
    required this.dark,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.titleColor,
    required this.lines,
    required this.isLoading,
    required this.isOn,
    required this.onToggle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32;
    final imageSize = cardWidth * 0.38;
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColor.movBlue.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...lines,
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: isLoading ? null : onToggle,
                      child: Opacity(
                        opacity: isLoading ? 0.5 : 1.0,
                        child: Container(
                          width: cardWidth * 0.48,
                          height: 40,
                          decoration: BoxDecoration(
                            color: dark ? AppColor.black : AppColor.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: dark
                                  ? AppColor.movBlue.withValues(alpha: 0.6)
                                  : AppColor.royalBlue,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: isOn
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    width: 48,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColor.royalBlue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: isLoading
                                        ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: AppColor.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                        : const Icon(
                                      Icons.fast_forward,
                                      color: AppColor.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: isOn ? 0 : 16),
                                  child: Text(
                                    isOn ? AppLocalizations.of(context)!.off : AppLocalizations.of(context)!.on,
                                    style: TextStyle(

                                      color: dark ? AppColor.white : AppColor.royalBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(image, width: imageSize, height: imageSize),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final bool dark;
  final bool forceWhite;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.dark,
    this.forceWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = forceWhite
        ? AppColor.white
        : dark
        ? AppColor.white
        : AppColor.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label : $value",
        style: TextStyle(color: color, fontSize: 13),
      ),
    );
  }
}