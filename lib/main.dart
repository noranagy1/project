import 'package:attendo/core/appStyle.dart';
import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:attendo/ui/register/screen/register_screen.dart';
import 'package:attendo/ui/splash/screen/start_screen.dart';
import 'package:attendo/ui/views/profileView.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppStyle.lightTheme,
      darkTheme: AppStyle.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
    );
  }
}