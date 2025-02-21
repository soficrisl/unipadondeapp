import 'package:flutter/material.dart';

class RegisterProvView extends StatelessWidget {
  const RegisterProvView({super.key});

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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                const Color(0xFF8CB1F1),
                Colors.white,
                ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Registro", style:TextStyle(color:Colors.white, fontSize: 45, fontWeight: FontWeight.w700, fontFamily: 'San Francisco', )),
                     Text("Bienvenido PROVEEDOR: ", style:TextStyle(color:Colors.white, fontSize: 17, fontWeight: FontWeight.w400, fontFamily: 'San Francisco',),)
                  ],
                )
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(32),
                        child: Column(
                        children: [
                          SizedBox(height: 60),

                          // ! cajita form
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(58, 118, 110, 106),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                                )
                              ]
                            ),

                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158),)),
                                  ),


                                  //EMAIL
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none

                                    ),
                                  ),
                                ),
                                

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //USUARIO
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Nombre de usuario",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none

                                    ),
                                  ),
                                ),
                                

                                 Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //PASSWORD
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Contraseña",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none

                                    ),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //CONFIRMAR PASSWORD
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Confirmar contraseña",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),

                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //RIF
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "RIF del negocio",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none

                                    ),
                                  ),
                                ),
                                
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //NOMBRE NEGOCIO
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Nombre del negocio",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none

                                    ),
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //NAME
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Nombre",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //LAST NAME
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Apellido/s",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //CI
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Cédula",
                                      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),
                                      border: InputBorder.none

                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color.fromARGB(200, 158, 158, 158))),
                                  ),

                                  //SEX
                                  child: DropdownMenu(
                                    hintText: "Sexo",
                                    
                                    dropdownMenuEntries: <DropdownMenuEntry<String>> [
                                      DropdownMenuEntry(value: 'Masculino', label: 'Masculino'),
                                      DropdownMenuEntry(value: 'Femenino', label: 'Femenino'),
                                    ],
                                  ),
                                ),

                              ],
                            )
                          ),
                          
                          SizedBox(height: 30,),

                          //boton Registrate
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFF8CB1F1),
                            ),
                            child: Center(
                              child: Text ("Regístrate", style:TextStyle(color:Colors.white,fontSize: 16,fontFamily: 'San Francisco', fontWeight: FontWeight.bold)),
                            ),
                          ),

                          //Registrar
                          SizedBox(height: 5,),
                          Text("-------------------------------------------------------------", style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 5,),
                          Text("¿Ya tienes una cuenta?", style: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),),
                          SizedBox(height: 10,),

                          // Boton Iniciar sesión 
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFFFAAF90),
                            ),
                            child: Center(
                              child: Text ("Iniciar sesión", style:TextStyle(color: Colors.white,fontSize: 16, fontFamily: 'San Francisco', fontWeight: FontWeight.bold)),
                            ),
                          ),

                          //Proveedor
                          SizedBox(height: 20,),
                          Text("¿No eres proveedor? Ingresa como", style: TextStyle(color: Colors.grey,fontFamily: 'San Francisco',),),
                          Text("ESTUDIANTE", 
                          style: TextStyle(
                            color: const Color(0xFF8CB1F1), 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'San Francisco',),),
                          SizedBox(height: 20,),

                        ],
                      ),
                      ),
                  )
                  )
                )
            ],
          ),
          ),
      ),
    );
  }
}
