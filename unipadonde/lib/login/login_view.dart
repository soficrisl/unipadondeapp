import 'package:unipadonde/validations.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/landingpage/landing_view.dart';
import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/loginprov/loginprov_mv.dart';
import 'package:unipadonde/register/register_vm.dart';
//import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/repository/supabase.dart';
import 'package:flutter/scheduler.dart';

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
  final _recoverController = TextEditingController();

  final loginVm _viewModel = loginVm(); // Instanciamos el view model

  // ! POP UP
  Future<void> _showPopup(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 16,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el popup
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'San Francisco',
                  color: Color(0xFF8CB1F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //Login function
  void login() async {
  final mail = _emailController.text;
  final password = _passwordController.text;

  // Validación del correo electrónico
  final emailValidation = Validations.validateEmail(mail);
  if (emailValidation != null) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showPopup(emailValidation);
      }
    });
    return;
  }

  // Validación de la contraseña (no vacía)
  final passwordValidation = Validations.validateNotEmpty(password, "Contraseña");
  if (passwordValidation != null) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showPopup(passwordValidation);
      }
    });
    return;
  }

  // Attempt to login
  try {
    final session = await authService.signIn(mail, password);
    final authUserId = session.user?.id;

    if (authUserId != null) {
      final data = await _viewModel.fetchUserId(mail);

      // Verificar si data es nulo
      if (data == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showPopup('No se encontró el usuario en la base de datos.');
          }
        });
        return;
      }

      final userId = data[0];
      final type = data[1];

      if (userId != null && type == 'S') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Landing(userId: userId)),
        );
      } else {
        _showPopup('No tienes permisos para acceder como estudiante.');
      }
    }
  } on AuthException catch (error) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (error.code == "invalid_credentials") {
          _showPopup('Verifique que el correo y la contraseña sean correctos.');
        } else {
          _showPopup('Error de autenticación.');
        }
      }
    });
  } catch (error) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showPopup('Verifique que el correo y la contraseña sean correctos.');
      }
    });
  }
}

  Future openInput() => showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Text(
                  "Ingresa el correo para cambiar tu contraseña",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 5,
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      TextField(
                        controller: _recoverController,
                        decoration: InputDecoration(
                            hintText: "Introduce tu correo",
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 208, 223, 250), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: Size(
                                double.infinity, 50), // Set height and width
                            padding: EdgeInsets.symmetric(
                                horizontal: 30), // Horizontal padding
                          ),
                          child: Text("Recuperar contraseña",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'San Francisco',
                                  fontWeight: FontWeight.bold))),
                    ])),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Permite el desplazamiento cuando el teclado aparece
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
                                      hintText: "Contraseña",
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
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            openInput();
                          },
                          child: Text(
                            "RECUPÉRALA",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 117, 117, 117),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'San Francisco',
                            ),
                          )),
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
                        "¿No tienes cuenta?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'San Francisco',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Boton Registrar
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterVM()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFFA500), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: Size(
                                double.infinity, 50), // Set height and width
                            padding: EdgeInsets.symmetric(
                                horizontal: 30), // Horizontal padding
                          ),
                          child: Text("Registrate",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'San Francisco',
                                  fontWeight: FontWeight.bold))),

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
                      GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const loginVmProv())),
                          child: Text(
                            "PROVEEDOR",
                            style: TextStyle(
                              color: const Color(0xFF8CB1F1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'San Francisco',
                            ),
                          )),
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
