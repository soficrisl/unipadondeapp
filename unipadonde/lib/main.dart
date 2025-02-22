import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/favoritespage/favspage_view.dart';
import 'package:unipadonde/landingpage/landing_view.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discount App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/start', // Ruta inicial
      routes: {
        '/landing': (context) => Landing(),
        '/start': (context) => StartView()

        //'/login': (context) => LoginProvView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/favorites') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => Favspage(userId: userId),
          );
        }
        return null; // Default case
      },
      home: const StartView(),
    );
  }
}
