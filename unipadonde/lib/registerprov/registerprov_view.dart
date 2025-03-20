import 'package:flutter/material.dart';
import 'package:unipadonde/loginprov/loginprov_mv.dart';
import 'package:unipadonde/register/register_vm.dart';
import 'package:unipadonde/repository/supabase.dart';
import 'package:unipadonde/validations.dart'; // Importar validaciones

final _formKey = GlobalKey<FormState>();

class RegisterProvView extends StatefulWidget {
  const RegisterProvView({super.key});

  @override
  State<RegisterProvView> createState() => _RegisterProvViewState();
}

class _RegisterProvViewState extends State<RegisterProvView> {
  final authService = AuthenticationService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ciController = TextEditingController();
  String? selectedValue = "Femenino";
  bool possible = true;

  void signUp() async {
    final authService = AuthenticationService();
    final createuser = UserDataBase();
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final lastname = _lastnameController.text;
    final ci = int.parse(_ciController.text);

    String sex = "F";
    if (selectedValue == "Masculino") {
      sex = "M";
    } else {
      sex = "F";
    }
    final usertype = "B";
    try {
      await authService.signUp(email, password);
      await createuser.createUser(
          email, password, ci, name, lastname, sex, usertype, '');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        //nose
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                        "Bienvenido PROVEEDOR: ",
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
                                          validator: Validations.validateEmail,
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
                                        child: TextFormField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                              hintText: "Contraseña",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator:
                                              Validations.validatePassword,
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
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                              hintText: "Nombre",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: Validations.validateName,
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
                                          controller: _lastnameController,
                                          decoration: InputDecoration(
                                              hintText: "Apellido",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator:
                                              Validations.validateLastName,
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
                                          controller: _ciController,
                                          decoration: InputDecoration(
                                              hintText: "Cédula",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'San Francisco',
                                              ),
                                              border: InputBorder.none),
                                          validator: Validations.validateCI,
                                        ),
                                      ),

                                      // ! SEXO
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.5,
                                              color: const Color.fromARGB(
                                                  200, 158, 158, 158),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: DropdownButton<String>(
                                            value: selectedValue,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                            underline: Container(
                                              height: 1,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedValue = newValue!;
                                              });
                                            },
                                            items: const [
                                              DropdownMenuItem<String>(
                                                  value: 'Femenino',
                                                  child: Text("Femenino")),
                                              DropdownMenuItem<String>(
                                                  value: 'Masculino',
                                                  child: Text("Masculino"))
                                            ]),
                                      ),

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
                                "¿Ya tienes una cuenta?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'San Francisco',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              // Boton Iniciar sesión
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                loginVmProv()));
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
                                "¿No eres proveedor? Ingresa como",
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
                                              const RegisterVM())),
                                  child: Text(
                                    "ESTUDIANTE",
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
