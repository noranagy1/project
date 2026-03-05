import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/color_manager.dart';
import 'package:flutter/material.dart';
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onTap;
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
            child: Icon(
              Icons.person_rounded,
              size: 50,
              color: Color(0xFF4E97D8),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0xFF4E97D8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Color(0xFF4E97D8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}