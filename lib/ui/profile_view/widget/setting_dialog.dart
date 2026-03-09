import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/providers/locale_provider.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/ui/profile_view/widget/option_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});
  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  String selectedLanguage = "Eng";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? ColorManager.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.l10n.settings,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                    )),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close,
                    color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(color: isDark ? ColorManager.darkDivider : Colors.grey.shade300),
            SizedBox(height: 10),

            /// Theme
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.theme),
              trailing: Text(
                isDark ? context.l10n.dark : context.l10n.light,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => OptionDialog(
                    title: context.l10n.theme,
                    options: ["Light", "Dark"], // ثابتين
                    currentValue: isDark ? "Dark" : "Light",
                  ),
                );
                if (result != null) {
                  themeProvider.setTheme(result == "Dark");
                }
              },
            ),

            /// Language
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.language),
              trailing: Text(selectedLanguage, style: TextStyle(color: Colors.grey)),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => OptionDialog(
                    title: context.l10n.language,
                    options: ["Eng", "Ar"],
                    currentValue: selectedLanguage,
                  ),
                );
                if (result != null) {
                  setState(() => selectedLanguage = result);
                  final locale = result == "Ar" ? const Locale('ar') : const Locale('en');
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}