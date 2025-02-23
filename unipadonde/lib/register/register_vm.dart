import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/material.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
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

  //obtener id del usuario como una consulta a la base de datos
  Future<int?> fetchUserId(String mail) async {
    final supabase = Supabase.instance.client;

    final response =
        await supabase.from('usuario').select('id').eq('mail', mail).single();
    if (response != null) {
      return response['id'];
    }
    return null;
  }

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
          //estoy provando como obtener el userid
          if (session != null) {
            final mail = session.user?.email ?? '';
            if (mail.isNotEmpty) {
              return FutureBuilder<int?>(
                future: fetchUserId(mail),
                builder: (context, userIdSnapshot) {
                  if (userIdSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Scaffold(
                        body: Center(
                            child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF8CB1F1),
                      color: Colors.white,
                    )));
                  }

                  final userId = userIdSnapshot.data;
                  if (userId != null) {
                    return Landing(userId: userId);
                  } else {
                    return const RegisterView();
                  }
                },
              );
            } else {
              return const RegisterView();
            }
          } else {
            return const RegisterView();
          }
        });
  }
}
