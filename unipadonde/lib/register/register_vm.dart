import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/material.dart';

import 'package:unipadonde/profilepage/profile_view.dart';
import 'package:unipadonde/register/register_view.dart';

class UserDataBase {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUser(String email, String password, int ci, String name,
      String lastname, String sex, String usertype, String universidad) async {
    await _supabase.from('usuario').insert({
      'id': ci,
      'password': password,
      'name': name,
      'lastname': lastname,
      'mail': email,
      'sex': sex,
      'usertype': usertype
    });
    if (universidad != '') {
      await _supabase
          .from('estudiante')
          .update({'universidad': universidad}).eq('id', ci);
    }
  }
}

class RegisterVM extends StatelessWidget {
  const RegisterVM({super.key});

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
            return const ProfilePage();
          } else {
            return const RegisterView();
          }
        });
  }
}
