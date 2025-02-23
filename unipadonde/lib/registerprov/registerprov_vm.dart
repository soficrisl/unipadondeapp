import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/landingpage/landing_view.dart';

import 'package:unipadonde/profilepage/profile_view.dart';
import 'package:unipadonde/registerprov/registerprov_view.dart';

class RegisterProvVM extends StatelessWidget {
  const RegisterProvVM({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
              backgroundColor: Color(0xFF8CB1F1),
              color: Colors.white,
            )));
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            return const Landing();
          } else {
            return const RegisterProvView();
          }
        });
  }
}
