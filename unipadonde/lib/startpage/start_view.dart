import 'package:flutter/material.dart';
import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/loginprov/loginprov_view.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina el banner de debug
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¿Eres Proveedor o Estudiante?',
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                // Botón de Estudiante
                ElevatedButton(
                  onPressed: () {
                    // Navega a la pantalla LoginView
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginVm()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAAF90),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Estudiante',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'San Francisco',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botón de Proveedor
                ElevatedButton(
                  onPressed: () {
                    // Navega a la pantalla LoginProvView
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginProvView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CB1F1),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Proveedor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'San Francisco',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
