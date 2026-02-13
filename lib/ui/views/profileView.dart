import 'package:attendo/ui/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:gap/gap.dart';
class Profileview extends StatefulWidget {
  const Profileview({super.key});
  @override
  State<Profileview> createState() => _ProfileviewState();
}
class _ProfileviewState extends State<Profileview> {
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  Future<void> logout() async {
    await authRepo.logout();
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => LoginScreen(),
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Gap(70),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                logout();
              }
            ),
          ],
        ),
      ),
    );
  }
}