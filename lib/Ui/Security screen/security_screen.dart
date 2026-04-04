import 'package:flutter/material.dart';
import 'package:new_project/Ui/Security%20screen/StatusBox.dart';
import 'package:new_project/Ui/Security%20screen/items.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/custom/News%20summary/newsSummary.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/data-list/data_list.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {

    final dark = Provider.of<ThemeProvider>(context).isDarkMode;

    return CustomScaffold(
      image: AppImage.Logo,
      icons: Icon(Icons.menu, color: AppColor.royalBlue, size: 30),
      onIconPressed: () {
        showMenu(
          color: dark ? AppColor.darkBackground : AppColor.white,
          context: context,
          position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          items: [
            PopupMenuItem(
              enabled: false,
              child: SizedBox(width: 250, child: DataList()),
            ),
          ],
        );
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataFile(name: UserSession.name, email: ''),
              const SizedBox(height: 10),
              Center(
                child: NewsSummary(
                  lottie: AppImage.greenStatus,
                  title: AppLocalizations.of(context)!.gate_control,
                  description: AppLocalizations.of(context)!.on_site,
                  date: "42",
                  description2: AppLocalizations.of(context)!.vehicles,
                  date2: "7",
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.gate_control,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: UserSession.gateStatus,
                    builder: (context, isOpen, _) {
                      return StatusBox(
                        image: AppImage.gateDark,
                        title: AppLocalizations.of(context)!.external_gate,
                        description: isOpen ? AppLocalizations.of(context)!.open : AppLocalizations.of(context)!.close,
                        isOpen: isOpen,
                        onChanged: (value) {
                          UserSession.gateStatus.value = value;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: UserSession.cameraStatus,
                    builder: (context, isOn, _) {
                      return StatusBox(
                        image: AppImage.camiraDark,
                        title: AppLocalizations.of(context)!.gate_camera,
                        description: isOn ? AppLocalizations.of(context)!.work : AppLocalizations.of(context)!.close ,
                        isOpen: isOn,
                        onChanged: (value) {
                          UserSession.cameraStatus.value = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.quick_actions,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Items(
                        image: AppImage.qrLight,
                        title:AppLocalizations.of(context)!.qr,
                        routeName: AppRoutes.QR.name,
                      ),
                      Items(
                        image: AppImage.Attendance,
                        title: AppLocalizations.of(context)!.attendance_report,
                        routeName: AppRoutes.AttReport.name,
                      ),
                      Items(
                        image: AppImage.manualRecording,
                        title: AppLocalizations.of(context)!.attend,
                        routeName: AppRoutes.manualAtt.name,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Items(
                        image: AppImage.complaint,
                        title: AppLocalizations.of(context)!.submit_complaint,
                        routeName: AppRoutes.complaint.name,
                      ),
                      Items(
                        image: AppImage.CarLight,
                        title: AppLocalizations.of(context)!.vehicle_registration,
                        routeName: AppRoutes.vehicleReport.name,
                      ),
                      Items(
                        image: AppImage.stutusLight,
                        title: AppLocalizations.of(context)!.site_status,
                        routeName: AppRoutes.status.name,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}