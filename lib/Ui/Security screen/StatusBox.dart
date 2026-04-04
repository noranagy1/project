import 'package:flutter/material.dart';
import 'package:new_project/custom/toggle.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/l10n/app_localizations.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class StatusBox extends StatelessWidget {
  const StatusBox({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.isOpen,
    required this.onChanged,
  });

  final String image;
  final String title;
  final String description;
  final bool isOpen;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: (MediaQuery.of(context).size.width / 2) - 20,
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkBackground : AppColor.white,
              borderRadius: BorderRadius.circular(16),
              border: isDark
                  ? Border.all(
                color: AppColor.movBlue.withValues(alpha: 0.8),
                width: 1.5,
              )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColor.green.withValues(alpha: 0.14)
                              : AppColor.red.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isOpen
                              ? AppLocalizations.of(context)!.on_line
                              : AppLocalizations.of(context)!.off_line,
                          style: TextStyle(
                            color: isOpen ? AppColor.green : AppColor.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: isOpen
                          ? AppColor.green.withValues(alpha: 0.14)
                          : AppColor.red.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(image, width: 35, height: 35),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColor.white : AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColor.gray,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Divider(
                    color: isDark
                        ? AppColor.movBlue.withValues(alpha: 0.3)
                        : AppColor.softGray,
                    thickness: 1,
                  ),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isOpen
                            ? AppLocalizations.of(context)!.open
                            : AppLocalizations.of(context)!.close,
                        style: const TextStyle(
                          color: AppColor.royalBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ToggleSwitch(
                        value: isOpen,
                        onChanged: onChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }}