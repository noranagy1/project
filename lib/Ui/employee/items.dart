import 'package:flutter/material.dart';
import 'package:new_project/design/AppColor.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class Item extends StatelessWidget {
  const Item({super.key, required this.image, required this.title, required this.routeName});
  final String image;
  final String title;
  final routeName;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Container(
          width: 150,
          height: 130,
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkBackground : AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: isDark
                ? Border.all(color: AppColor.movBlue.withValues(alpha: 0.8), width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 70, height: 70),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColor.white : AppColor.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}