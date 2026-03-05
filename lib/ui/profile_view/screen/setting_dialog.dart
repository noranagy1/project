import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/locale_provider.dart';
import 'package:attendo/ui/profile_view/screen/option_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});
  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}
class _SettingsDialogState extends State<SettingsDialog> {
  late String selectedTheme = context.l10n.light;
  String selectedLanguage = "Eng";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ===== Header (Settings + X) =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.settings,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close),
                ),
              ],
            ),
             SizedBox(height: 15),
            Divider(color: Colors.grey.shade300),
             SizedBox(height: 10),
            /// ===== Theme =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.theme),
              trailing: Text(
                selectedTheme,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => OptionDialog(
                    title: context.l10n.theme,
                    options: [context.l10n.light, context.l10n.dark],
                    currentValue: selectedTheme,
                  ),
                );
                if (result != null) {
                  setState(() {
                    selectedTheme = result;
                  });
                }
              },
            ),
            /// ===== Language =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.language),
              trailing: Text(
                selectedLanguage,
                style: TextStyle(color: Colors.grey),
              ),
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
                  setState(() {
                    selectedLanguage = result;
                  });
                  final locale = result == "Ar" ? const Locale('ar') : const Locale('en');
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
                }
              },
            ),          ],
        ),
      ),
    );
  }
}