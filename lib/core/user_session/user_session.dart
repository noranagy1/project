import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String token = '';
  static String name = '';
  static String role = '';
  static String email = '';
  static String employeeId = '';


  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('role', role);
    await prefs.setString('email', email);
  }


  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    name = prefs.getString('name') ?? '';
    role = prefs.getString('role') ?? '';
    email = prefs.getString('email') ?? '';
  }


  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = '';
    name = '';
    role = '';
    email = '';
  }

  static ValueNotifier<bool> gateStatus = ValueNotifier(false);
  static ValueNotifier<bool> cameraStatus = ValueNotifier(false);
}