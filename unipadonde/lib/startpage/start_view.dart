import 'package:flutter/material.dart';
import 'package:unipadonde/loginprov/loginprov_mv.dart';
import 'package:unipadonde/login/login_vm.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina el banner de debug
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título UniPaDonde con degradado
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      const Color(0xFFFFA500), // Naranja
                      const Color(0xFF7A9BBF), // Azul
                      const Color(0xFF8CB1F1), // Azul claro
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'UniPaDonde', // Título
                    style: TextStyle(
                      color: Colors.white, // El color del texto debe ser blanco
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'San Francisco',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 120),
                // Texto "Eres:" centrado
                Text(
                  '¿Quién eres?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
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
                    backgroundColor: Color(0xFFFFA500),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Estudiante',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'San Francisco',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Botón de Proveedor
                ElevatedButton(
                  onPressed: () {
                    // Navega a la pantalla LoginProvView
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginVmProv()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CB1F1),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Proveedor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
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
