import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/reusable_components/submit_complaint.dart';
import 'package:attendo/ui/employee/screen/employee_screen.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/profile_view/screen/profile_edit.dart';
import 'package:attendo/ui/register/screen/register_screen.dart';
import 'package:attendo/ui/security/screen/security_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppStyle.lightTheme,
      darkTheme: AppStyle.darkTheme,
      themeMode: ThemeMode.light,
      home: SecurityScreen(),
    );
  }
}