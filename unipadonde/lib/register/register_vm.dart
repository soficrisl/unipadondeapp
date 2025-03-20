import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/material.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
import 'package:unipadonde/register/register_view.dart';

class UserDataBase {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUser(String email, String password, int ci, String name,
    String lastname, String sex, String usertype, String universidad) async {
  try {
    await _supabase.from('usuario').insert({
      'id': ci,
      'password': password,
      'name': name,
      'lastname': lastname,
      'mail': email,
      'sex': sex,
      'usertype': usertype,
    });

    if (universidad.isNotEmpty) {
      await _supabase
          .from('estudiante')
          .update({'universidad': universidad}).eq('id', ci);
    }
  } catch (e) {
    print("Error al crear el usuario: $e");
    rethrow; // Relanzar el error para manejarlo en el método `signUp`
  }
}
}

class RegisterVM extends StatelessWidget {
  const RegisterVM({super.key});

  //obtener id del usuario como una consulta a la base de datos
  Future<int?> fetchUserId(String mail) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('usuario')
          .select('id')
          .eq('mail', mail)
          .maybeSingle();

      return response?['id'];
    } catch (e) {
      return null;
    }
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
          if (session == null) {
            return const RegisterView();
          }

          final mail = session.user.email ?? '';
          if (mail.isEmpty) {
            return const RegisterView();
          }

          return FutureBuilder<int?>(
            future: fetchUserId(mail),
            builder: (context, userIdSnapshot) {
              if (userIdSnapshot.connectionState == ConnectionState.waiting) {
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
                if (context.mounted) {
                }
                return const RegisterView();
              }
            },
          );
        });
  }
}
