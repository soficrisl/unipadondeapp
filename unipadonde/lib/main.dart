import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_view.dart';
import 'package:unipadonde/favoritesbusinesspage/favsbusiness_view.dart';
import 'package:unipadonde/favoritespage/favspage_view.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/profilepage/profile_view.dart';
import 'package:unipadonde/profileprovpage/profileprov_view.dart';
import 'package:unipadonde/startpage/start_view.dart';

const supabaseUrl = 'https://atswkwzuztfzaerlpcpc.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://atswkwzuztfzaerlpcpc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0c3drd3p1enRmemFlcmxwY3BjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5MjczNTcsImV4cCI6MjA1MzUwMzM1N30.FzMP9I3qs9aVol2njwWYjFPKJAgtBE-RkcQ-UrinA2A');
  runApp(const MyApp());
}

final SupabaseClient supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discount App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/start', // Ruta inicial
      //rutas pasando el userId a las vistas
      onGenerateRoute: (settings) {
        final userId = settings.arguments as int?;
        if (userId == null) {
          return MaterialPageRoute(
            builder: (context) => const loginVm(),
          );
        }

        switch (settings.name) {
          case '/landing':
            return MaterialPageRoute(
              builder: (context) => Landing(userId: userId),
            );

          case '/favorites':
            return MaterialPageRoute(
              builder: (context) => Favspage(userId: userId),
            );

          case '/profile':
            return MaterialPageRoute(
              builder: (context) => ProfilePage(userId: userId),
            );

          case '/profileprov':
            return MaterialPageRoute(
              builder: (context) => ProfileProvPage(userId: userId),
            );

          case '/favsbusiness':
            return MaterialPageRoute(
              builder: (context) => Favsbusinesspage(userId: userId),
            );
          case '/cdiscount':
            return MaterialPageRoute(
              builder: (context) => CDiscountPage(userId: userId),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => StartView(),
            );
        }
      },
      home: const StartView(),
    );
  }
}
