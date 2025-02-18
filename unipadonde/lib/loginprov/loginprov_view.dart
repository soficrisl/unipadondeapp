import 'package:flutter/material.dart';

class LoginProvView extends StatelessWidget {
  const LoginProvView({super.key});

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
                const Color(0xFFB4CBF7),
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
                     Text("Login", style:TextStyle(color:Colors.white, fontSize: 45, fontWeight: FontWeight.w700, fontFamily: 'San Francisco', )),
                     Text("Bienvenido Proveedor: ", style:TextStyle(color:Colors.white, fontSize: 17, fontWeight: FontWeight.w400, fontFamily: 'San Francisco',),)
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
                                      hintText: "Usuario",
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
                                )
                              ],
                            )
                          ),
                          
                          //Forgot password
                          SizedBox(height: 30,),
                          Text("Olvidaste tu contraseña?", style: TextStyle(color: Colors.grey,fontFamily: 'San Francisco',),),
                          Text("RECUPERALA", style: TextStyle(color: const Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.bold,fontFamily: 'San Francisco',),),
                          SizedBox(height: 20,),

                          //boton Login
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFB4CBF7),
                            ),
                            child: Center(
                              child: Text ("Login", style:TextStyle(color:Colors.white,fontSize: 16,fontFamily: 'San Francisco', fontWeight: FontWeight.bold)),
                            ),
                          ),

                          //Registrar
                          SizedBox(height: 5,),
                          Text("-----------------------------------------------------------------------------------------", style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 5,),
                          Text("No tienes cuenta?", style: TextStyle(color: Colors.grey, fontFamily: 'San Francisco',),),
                          SizedBox(height: 10,),

                          // Boton Registrar 
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFFFCC9B5),
                            ),
                            child: Center(
                              child: Text ("Registrate", style:TextStyle(color: Colors.white,fontSize: 16, fontFamily: 'San Francisco', fontWeight: FontWeight.bold)),
                            ),
                          ),

                          //Proveedor
                          SizedBox(height: 20,),
                          Text("No eres Proveedor? Ingresa como", style: TextStyle(color: Colors.grey,fontFamily: 'San Francisco',),),
                          Text("ESTUDIANTE", 
                          style: TextStyle(
                            color: const Color(0xFFB4CBF7), 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'San Francisco',),),
                          SizedBox(height: 20,),

                        ],
                      ),
                      ),
                  )
                  )
            ],
          ),
          ),
      ),
    );
  }
}
// FADEANIMATION¿?
