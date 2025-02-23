import 'package:flutter/material.dart';
import 'package:unipadonde/repository/supabase.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthenticationService();

  void logout() async {
    await authService.singOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
        appBar: AppBar(title: const Text('Profile'), actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ]),
        body: Center(
          child: Text(currentEmail.toString()),
        ));
  }
}
