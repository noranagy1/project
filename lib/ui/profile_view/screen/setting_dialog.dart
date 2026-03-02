import 'package:attendo/ui/profile_view/screen/option_dialog.dart';
import 'package:flutter/material.dart';
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});
  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}
class _SettingsDialogState extends State<SettingsDialog> {
  String selectedTheme = "Light";
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
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 10),
            /// ===== Theme =====
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Theme"),
              trailing: Text(
                selectedTheme,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => OptionDialog(
                    title: "Theme",
                    options: const ["Light", "Dark"],
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
              title: const Text("Language"),
              trailing: Text(
                selectedLanguage,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => OptionDialog(
                    title: "Language",
                    options: const ["Eng", "Ar"],
                    currentValue: selectedLanguage,
                  ),
                );
                if (result != null) {
                  setState(() {
                    selectedLanguage = result;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}