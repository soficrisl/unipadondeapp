import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_view.dart';
import 'package:unipadonde/favoritesbusinesspage/favsbusiness_view.dart';
import 'package:unipadonde/favoritespage/favspage_view.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/profilepage/profile_view.dart';
import 'package:unipadonde/profileprovpage/profileprov_view.dart';
import 'package:unipadonde/business_view_prov/buspageprov_view.dart';

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
      theme: ThemeData(
        primaryColor: Color(0xFF8CB1F1), // Azul claro
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Puede representar el azul
        ).copyWith(
          primary: Color(0xFF8CB1F1), // Color principal de tu app
          secondary: Color(0xFFFFA500), // Naranja para detalles secundarios
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(
            color: Color(0xFF8CB1F1), // Color del texto flotante
            fontFamily: 'San Francisco',
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFF8CB1F1)), // Borde enfocado en azul
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFA500), // Fondo del botón en naranja
            foregroundColor: Colors.white, // Texto blanco en los botones
            textStyle: TextStyle(fontFamily: 'San Francisco'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/start', // Ruta inicial
      // Rutas pasando el userId a las vistas
      onGenerateRoute: (settings) {
        // Manejo seguro de settings.arguments
        int? userId;
        if (settings.arguments != null && settings.arguments is int) {
          userId = settings.arguments as int;
        }

        // Si userId es null, redirigir a una página por defecto
        if (userId == null) {
          return MaterialPageRoute(
            builder: (context) => const loginVm(),
          );
        }

        // Navegación basada en la ruta
        switch (settings.name) {
          case '/landing':
            return MaterialPageRoute(
              builder: (context) => Landing(
                  userId:
                      userId!), // Usamos el operador ! para indicar que userId no es null
            );

          case '/favorites':
            return MaterialPageRoute(
              builder: (context) => Favspage(
                  userId:
                      userId!), // Usamos el operador ! para indicar que userId no es null
            );

          case '/profile':
            return MaterialPageRoute(
              builder: (context) => ProfilePage(
                  userId:
                      userId!), // Usamos el operador ! para indicar que userId no es null
            );

          case '/profileprov':
            return MaterialPageRoute(
              builder: (context) => ProfileProvPage(
                  userId:
                      userId!), // Usamos el operador ! para indicar que userId no es null
            );

          case '/favsbusiness':
            return MaterialPageRoute(
              builder: (context) => Favsbusinesspage(
                  userId:
                      userId!), // Usamos el operador ! para indicar que userId no es null
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
