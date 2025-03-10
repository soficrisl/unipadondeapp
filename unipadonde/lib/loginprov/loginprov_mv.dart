import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/favoritesbusinesspage/favsbusiness_view.dart';
import 'package:unipadonde/loginprov/loginprov_view.dart';
import 'package:flutter/scheduler.dart';

class loginVmProv extends StatelessWidget {
  const loginVmProv({super.key});

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
        if (session == null) {
          return const LoginProvView();
        }

        final mail = session.user.email ?? '';

        if (mail.isEmpty) {
          return const LoginProvView();
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
              return Favsbusinesspage(userId: userId);
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error al obtener el ID del usuario.")),
                  );
                }
              });
              return const LoginProvView();
            }
          },
        );
      });
}
}
