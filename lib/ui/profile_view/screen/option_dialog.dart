import 'package:attendo/core/appStyle.dart';
import 'package:flutter/material.dart';
class OptionDialog extends StatelessWidget {
  final String title;
  final List<String> options;
  final String currentValue;
  const OptionDialog({
    required this.title,
    required this.options,
    required this.currentValue,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 120),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          return Column(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context, option),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: option == currentValue
                          ? Colors.blue
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              if (option != options.last)
                const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}