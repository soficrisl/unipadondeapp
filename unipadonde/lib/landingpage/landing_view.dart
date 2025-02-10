import 'package:flutter/material.dart';
import 'package:unipadonde/landingpage/landing_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<Discount> discounts = listOfDIscounts();
  // list of images min 2:44 -> son para el carrousel que no voy a usar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 144, 199, 247),
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        title: Text("UnipaDonde",
            style: GoogleFonts.playfairDisplay(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        leading: IconButton(
          iconSize: 40,
          onPressed: () {},
          icon: SvgPicture.asset("assets/icons/menu.svg"),
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 12),
              width: 40,
              height: 40,
              decoration:
                  BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              child:
                  Image.asset("assets/images/profile.png", fit: BoxFit.contain))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //carousel()
            //aqui va el widget del carrusel de categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), //para evitar interferencias en el scrolling
                shrinkWrap: true,
                itemCount: 6, //(provicional) cuantos son
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 210, //altura de cda fila
                    mainAxisSpacing: 24, //separacion vertical
                    crossAxisSpacing: 13, //separacion horizontal entre items
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Container(
                      //OJOOO aqui deberia retornar un widget (de una carpeta aparte con la info de cada descuento fitted en el container)
                      color:
                          const Color(0xFFF1F1F1) //poner un color personalizado
                      );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 65,
          margin: const EdgeInsets.symmetric(
              horizontal: 12, //espacio margen horizontal
              vertical: 20 //espacio margen de abajo
              ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(69),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FeatherIcons.home,
                  size: 30,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FeatherIcons.search,
                  size: 30,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FeatherIcons.heart,
                  size: 30,
                ))
          ])),
    );
  }
}

/*
Widget carousel () {
  return Stack(
    children: [
      //aqui va el carrusel de categorias
    ],
  )
}*/
