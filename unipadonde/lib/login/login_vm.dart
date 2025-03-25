import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
import 'package:unipadonde/login/login_view.dart';
import 'package:flutter/scheduler.dart';

class loginVm extends StatelessWidget {
  const loginVm({super.key});

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
        return [response['id'], response['usertype']];
      } else {
        return null; // Devuelve null si no se encuentra el usuario
      }
    } catch (e) {
      print("Error al obtener el ID del usuario: $e");
      return null; // Devuelve null si hay un error
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
            return const LoginView();
          }

          final mail = session.user.email ?? '';

          if (mail.isEmpty) {
            return const LoginView();
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
                    ),
                  ),
                );
              }

              final data = userIdSnapshot.data;

              // Verificar si data es nulo
              if (data == null) {
                return const LoginView();
              }

              final userId = data == null ? null : data[0];
              final type = data == null ? null : data[1];

              if (userId != null && type == 'S') {
                return Landing(userId: userId);
              } else if (type == "B") {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'No tienes permisos para acceder como estudiante.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
                return const LoginView();
              } else {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Error al obtener el ID del usuario.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
                return const LoginView();
              }
            },
          );
        });
  }
}
