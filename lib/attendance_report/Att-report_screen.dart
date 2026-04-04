import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/attendance_report/attendance_cubit.dart';
import 'package:new_project/attendance_report/attendance_state.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/custom/scaffold.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/design/AppImage.dart';
import 'package:new_project/l10n/app_localizations.dart';

bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

class AttReport extends StatelessWidget {
  const AttReport({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceCubit>()..getReport(),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            image: AppImage.Logo,
            icons: const Icon(Icons.arrow_forward_ios, color: AppColor.royalBlue, size: 30),
            onIconPressed: () => Navigator.pop(context),
            body: BlocBuilder<AttendanceCubit, AttendanceState>(
              builder: (context, state) {

                if (state is AttendanceLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AttendanceErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: const TextStyle(color: AppColor.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<AttendanceCubit>().getReport(),
                          child: Text(AppLocalizations.of(context)!.try_again),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AttendanceSuccessState) {
                  final summary = state.model.summary;
                  final details = state.model.details;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _SummaryCard(
                              title: AppLocalizations.of(context)!.days_of_attendance,
                              value: "${summary.presentDays} ${AppLocalizations.of(context)!.day}",
                            ),
                            _SummaryCard(
                              title: AppLocalizations.of(context)!.days_of_absence,
                              value: "${summary.absentDays} ${AppLocalizations.of(context)!.day}",
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _LateCard(lateDays: "${summary.lateDays} ${AppLocalizations.of(context)!.day}"),

                        const SizedBox(height: 16),

                        details.isEmpty
                            ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              AppLocalizations.of(context)!.no_attendance_details_available,
                              style: TextStyle(
                                color: isDarkMode(context)
                                    ? AppColor.softGray
                                    : AppColor.gray,
                              ),
                            ),
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: details.keys.length,
                          itemBuilder: (context, index) {
                            final key = details.keys.elementAt(index);
                            final value = details[key];
                            return _DetailCard(
                              date: key,
                              timeIn: value['checkIn'] ?? '--',
                              timeOut: value['checkOut'] ?? '--',
                              status: value['status'] ?? '--',
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode(context);
    return Container(
      width: 160,
      height: 90,
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.8)
              : AppColor.softBlue,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? AppColor.softGray : AppColor.gray,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColor.royalBlue,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _LateCard extends StatelessWidget {
  final String lateDays;
  const _LateCard({required this.lateDays});

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.8)
              : AppColor.softBlue,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.late_days,
            style: TextStyle(
              color: dark ? AppColor.softGray : AppColor.gray,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lateDays,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String date;
  final String timeIn;
  final String timeOut;
  final String status;

  const _DetailCard({
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: dark ? AppColor.darkBackground : AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.8)
              : AppColor.softBlue,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: dark ? AppColor.white : AppColor.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == AppLocalizations.of(context)!.present
                        ? AppColor.green.withValues(alpha: 0.15)
                        : status == AppLocalizations.of(context)!.late
                        ? Colors.orange.withValues(alpha: 0.15)
                        : AppColor.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == AppLocalizations.of(context)!.present
                          ? AppColor.green
                          : status == AppLocalizations.of(context)!.late
                          ? Colors.orange
                          : AppColor.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: dark
                ? AppColor.movBlue.withValues(alpha: 0.3)
                : AppColor.softBlue,
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: _TimeBox(label: AppLocalizations.of(context)!.entry, time: timeIn, dark: dark)),
                const SizedBox(width: 12),
                Expanded(child: _TimeBox(label: AppLocalizations.of(context)!.exit, time: timeOut, dark: dark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final bool dark;

  const _TimeBox({required this.label, required this.time, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: dark ? AppColor.black : AppColor.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark
              ? AppColor.movBlue.withValues(alpha: 0.5)
              : AppColor.softBlue.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: dark ? AppColor.softGray : AppColor.gray,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(
              color: AppColor.royalBlue,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}