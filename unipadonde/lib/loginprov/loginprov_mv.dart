import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/landingprovpage/landingprov_view.dart';
import 'package:unipadonde/loginprov/loginprov_view.dart';
import 'package:flutter/scheduler.dart';

class loginVmProv extends StatelessWidget {
  const loginVmProv({super.key});

  //obtener id del usuario como una consulta a la base de datos
  Future<List<dynamic>?> fetchUserId(String mail) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('usuario')
          .select('id, usertype')
          .eq('mail', mail)
          .maybeSingle();
      if (response != null) {
        final newvalues = [response['id'], response['usertype']];
        return newvalues;
      }
      return null;
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
          return FutureBuilder<List<dynamic>?>(
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

              final data = userIdSnapshot.data;
              final userId = data![0];
              final type = data[1];

              if (userId != null && type == 'B') {
                return LandingProv(userId: userId);
              } else if (type != 'B') {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Debe ingresar como usuario.")),
                    );
                  }
                });
                return const LoginProvView();
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
