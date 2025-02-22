import 'package:flutter/material.dart';

import 'package:unipadonde/login/login_vm.dart';
import 'package:unipadonde/register/register_vm.dart';

import 'package:unipadonde/registerprov/registerprov_vm.dart';
import 'package:unipadonde/repository/supabase.dart';

final _formKey = GlobalKey<FormState>();
final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final authService = AuthenticationService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ciController = TextEditingController();
  final _universidadController = TextEditingController();
  String? selectedSex;
  bool possible = true;

  void signUp() async {
    final authService = AuthenticationService();
    final createuser = UserDataBase();

    final email = _emailController.text;
    final password = _passwordController.text;
    //final username = _usernameController;
    final name = _nameController.text;
    final lastname = _lastnameController.text;
    final ci = int.parse(_ciController.text);
    final universidad = _universidadController.text;
    String sex = "F";
    if (selectedSex == "Masculino") {
      sex = "M";
    } else {
      sex = "F";
    }
    final usertype = "S";
    try {
      await authService.signUp(email, password);
      await createuser.createUser(
          email, password, ci, name, lastname, sex, usertype, universidad);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // ! VALIDACION EMAIL
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'[\w-\.]+@(correo\.unimet\.edu\.ve)$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      possible = false;
      return 'Ingrese un correo correcto';
    }
    return null;
  }

  // ! VALIDACION USERNAME
  String? validUsername(String? username) {
    RegExp userRegex = RegExp(r'^[a-zA-Z0-9]+$');
    final isUserValid = userRegex.hasMatch(username ?? '');
    if (!isUserValid) {
      possible = false;
      return 'Ingrese un usuario correcto';
    }
    return null;
  }

  // ! VALIDACION NOMBRE Y APELLIDO
  String? validName(String? name) {
    RegExp userRegex = RegExp(r'^[a-zA-Z]+$');
    final isNameValid = userRegex.hasMatch(name ?? '');
    if (!isNameValid) {
      possible = false;
      return 'Ingreso inválido';
    }
    return null;
  }

  // ! VALIDACION CI
  String? validCI(String? ci) {
    RegExp userRegex = RegExp(r'^[0-9]+$');
    final isCIValid = userRegex.hasMatch(ci ?? '');
    if (!isCIValid) {
      possible = false;
      return 'Ingrese solo los números';
    }
    return null;
  }

  // ! VALIDACION UNIVERSIDAD
  String? validUni(String? uni) {
    RegExp userRegex = RegExp(r'^[a-zA-Z ]+$');
    final isUniValid = userRegex.hasMatch(uni ?? '');
    if (!isUniValid) {
      return 'Ingreso inválido';
    }
    return null;
  }

  // ! VALIDACION CONTRASEÑA
  String? validPassword(String? password) {
    RegExp userRegex = RegExp(r'^[a-zA-Z0-9&%_\-=@,\.;\*\+\$\\]+$');
    final isPasswordValid = userRegex.hasMatch(password ?? '');
    if (!isPasswordValid) {
      possible = false;
      return 'Ingreso inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Background
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
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
                      Text("Registro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'San Francisco',
                          )),
                      Text(
                        "Bienvenido ESTUDIANTE: ",
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
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              SizedBox(height: 60),

                              // * CAJA FORM
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(58, 118, 110, 106),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // !EMAIL
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                              hintText: "Email",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: validateEmail,
                                        ),
                                      ),

                                      // ! CONTRASEÑA
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                      ),

                                      // ! CONFIRMAR CONTRASEÑA
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Confirmar contraseña",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: validPassword,
                                        ),
                                      ),

                                      // ! NOMBRE
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Nombre",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: validName,
                                        ),
                                      ),

                                      // ! APELLIDO
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Apellido",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: validName,
                                        ),
                                      ),

                                      // ! NOMBRE UNIVERSIDAD
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Nombre de la Universidad",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: validUni,
                                        ),
                                      ),

                                      // ! CI
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                200, 158, 158, 158),
                                          )),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Cédula",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: validCI,
                                        ),
                                      ),

                                      // ! SEXO
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: const Color.fromARGB(
                                                        200, 158, 158, 158))),
                                          ),
                                          child: DropdownButton(
                                              value: selectedSex,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedSex = newValue!;
                                                });
                                              },
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      200, 158, 158, 158)),
                                              items: <String>[
                                                'Masculino',
                                                'Femenino'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList())),

                                      // ! BOTON REGISTRAR
                                      const SizedBox(height: 30),
                                      ElevatedButton(
                                          onPressed: () {
                                            possible = true;
                                            _formKey.currentState!.validate();
                                            if (possible) {
                                              signUp();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                                0xFF8CB1F1), // Background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            minimumSize: Size(double.infinity,
                                                50), // Set height and width
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    30), // Horizontal padding
                                          ),
                                          child: Text("REGISTRARSE",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'San Francisco',
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  ),
                                ),
                              ),

                              // ! Iniciar sesion
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "-------------------------------------------------------------",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "¿Ya tienes  una cuenta?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'San Francisco',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              // ! Boton Login
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => loginVm()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFFFAAF90), // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    minimumSize: Size(double.infinity,
                                        50), // Set height and width
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30), // Horizontal padding
                                  ),
                                  child: Text("Inicia Sesión",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'San Francisco',
                                          fontWeight: FontWeight.bold))),

                              //Proveedor
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "¿No eres estudiante? Ingresa como",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'San Francisco',
                                ),
                              ),

                              GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterProvVM())),
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
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
