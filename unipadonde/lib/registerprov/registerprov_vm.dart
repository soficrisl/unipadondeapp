import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
import 'package:unipadonde/registerprov/registerprov_view.dart';

class RegisterProvVM extends StatelessWidget {
  const RegisterProvVM({super.key});

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
            final mail = session.user.email ?? '';
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
                    return const RegisterProvView();
                  }
                },
              );
            } else {
              return const RegisterProvView();
            }
          } else {
            return const RegisterProvView();
          }
        });
  }
}
