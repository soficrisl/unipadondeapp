import 'package:flutter/material.dart';
//import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/repository/supabase.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  //Servicio de autentificacion
  final authService = AuthenticationService();

  //Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Login function
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Validación: Asegúrate de que los campos no estén vacíos
    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, ingresa tu correo y contraseña.")),
        );
      }
      return;
    }

    //Attempt to login
    try {
      await authService.signIn(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Asegúrate de que solo tienes un Scaffold en tu widget
      body: SingleChildScrollView(  // Permite el desplazamiento cuando el teclado aparece
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            const Color(0xFF8CB1F1),
            Colors.white,
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'San Francisco',
                          )),
                      Text(
                        "Bienvenido Estudiante: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'San Francisco',
                        ),
                      )
                    ],
                  )),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 60),

                      //cajita email y password
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(58, 118, 110, 106),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                    color: const Color.fromARGB(
                                        200, 158, 158, 158),
                                  )),
                                ),

                                //EMAIL
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                      hintText: "Email .unimet",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'San Francisco',
                                      ),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: const Color.fromARGB(
                                              200, 158, 158, 158))),
                                ),

                                //PASSWORD
                                child: TextField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                      hintText: "contraseña",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'San Francisco',
                                      ),
                                      border: InputBorder.none),
                                ),
                              )
                            ],
                          )),

                      //Forgot password
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Olvidaste tu contraseña?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      Text(
                        "RECUPERALA",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 117, 117, 117),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //boton Login
                      ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF8CB1F1), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: Size(
                                double.infinity, 50), // Set height and width
                            padding: EdgeInsets.symmetric(
                                horizontal: 30), // Horizontal padding
                          ),
                          child: Text("Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'San Francisco',
                                  fontWeight: FontWeight.bold))),

                      // Registrar
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "-----------------------------------------------------------------------------------------",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "No tienes cuenta?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Boton Registrar
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xFFFAAF90),
                        ),
                        child: Center(
                          child: Text("Registrate",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'San Francisco',
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),

                      // Proveedor
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "No eres estudiante? Ingresa como",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      Text(
                        "PROVEEDOR",
                        style: TextStyle(
                          color: const Color(0xFF8CB1F1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
