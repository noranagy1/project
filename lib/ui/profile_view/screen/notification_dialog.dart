import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:flutter/material.dart';
class NotificationDialog extends StatefulWidget {
  final String currentValue;
  const NotificationDialog({super.key, required this.currentValue});
  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}
class _NotificationDialogState extends State<NotificationDialog> {
  String notificationValue = "Allow";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 120), // 👈 بيصغّر العرض
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Allow
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: () => Navigator.pop(context, context.l10n.allow),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              child: Text(
                context.l10n.allow,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.currentValue == context.l10n.allow
                      ? Colors.blue
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Divider(height: 1),
          /// Mute
          InkWell(
            borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(16)),
            onTap: () => Navigator.pop(context, context.l10n.mute),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              child: Text(
                context.l10n.mute,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.currentValue == context.l10n.mute
                      ? Colors.blue
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}