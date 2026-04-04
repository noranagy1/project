import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/Ui/employee/items.dart';
import 'package:new_project/Ui/employee/report.dart';
import 'package:new_project/attendance_report/attendance_cubit.dart';
import 'package:new_project/attendance_report/attendance_state.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/profile/data-list/data_list.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/routes.dart';
import 'package:new_project/custom/News%20summary/newsSummary.dart';
import 'package:new_project/custom/data_file.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:provider/provider.dart';class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Provider.of<ThemeProvider>(context).isDarkMode;
    final name = ModalRoute.of(context)?.settings.arguments as String? ?? "User";
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? "name@gmail.com";

    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..getReport(),
      child: CustomScaffold(
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DataFile(name: name, email: email),
              const SizedBox(height: 20),
              Center(
                child: NewsSummary(
                  image: AppImage.Att,
                  title: AppLocalizations.of(context)!.monthly_activity,
                  description: AppLocalizations.of(context)!.attendance,
                  date: "25",
                  description2: AppLocalizations.of(context)!.absence,
                  date2: "5",
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Item(
                      image: AppImage.CarLight,
                      title: AppLocalizations.of(context)!.vehicle_entry,
                      routeName: AppRoutes.vehicleReport.name,
                    ),
                    Item(
                      image: AppImage.qrLight,
                      title: AppLocalizations.of(context)!.qr,
                      routeName: AppRoutes.QR.name,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 219),
                decoration: BoxDecoration(
                  color: dark ? AppColor.darkBackground : AppColor.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: dark
                        ? AppColor.movBlue.withValues(alpha: 0.8)
                        : AppColor.softBlue,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.activity,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              color: dark ? AppColor.white : AppColor.black,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.AttReport.name),
                            child: Container(
                              width: 84,
                              height: 27,
                              decoration: BoxDecoration(
                                color: AppColor.blue.withValues(alpha: 0.32),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.view_all,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: AppColor.blue),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      BlocBuilder<AttendanceCubit, AttendanceState>(
                        builder: (context, state) {
                          if (state is AttendanceLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }
                          if (state is AttendanceErrorState) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                    color: AppColor.red, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          if (state is AttendanceSuccessState) {
                            final details = state.model.details;
                            if (details.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.no_activity,
                                    style: TextStyle(
                                      color: dark
                                          ? AppColor.softGray
                                          : AppColor.gray,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final recentEntries =
                            details.entries.take(3).toList();
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: recentEntries.map((entry) {
                                final date = entry.key;
                                final value =
                                entry.value as Map<String, dynamic>;
                                final status = value['status'] ?? '--';
                                final timeIn = value['checkIn'] ?? '--';
                                final timeOut = value['checkOut'] ?? '--';
                                if (status ==
                                    AppLocalizations.of(context)!.absence) {
                                  return Report(
                                    image: AppImage.redStatus,
                                    date: date,
                                    abasence:
                                    AppLocalizations.of(context)!.absence,
                                  );
                                } else {
                                  return Report(
                                    image: AppImage.greenStatus,
                                    date: date,
                                    timeIn: timeIn,
                                    timeOut: timeOut,
                                  );
                                }
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.complaint.name),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: dark ? AppColor.darkBackground : AppColor.softBlue,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: dark
                          ? AppColor.movBlue.withValues(alpha: 0.8)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(AppImage.complaint, width: 72, height: 72),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.submit_complaint,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: dark ? AppColor.white : null,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.report_incident,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: dark ? AppColor.softGray : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: dark ? AppColor.movBlue : AppColor.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}