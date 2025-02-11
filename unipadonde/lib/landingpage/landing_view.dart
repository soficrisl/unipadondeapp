import 'package:flutter/foundation.dart';
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
  //lista de categorias
  final List<String> categories = ['Food', 'Travel', 'Games'];
  //lista de categorias seleccionadas
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    //variable para filtrar los descuentos segun categoria
    final filterDiscount = listOfDIscounts.where((discount) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(discount.category);
    }).toList(); //es una lista, hay que convertirlo a lista con este metodo

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
      body: Column(
        children: [
          //este container muestra los "botones" de categorias
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories
                  .map((category) => FilterChip(
                      selected: selectedCategories.contains(category),
                      label: Text(category),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      }))
                  .toList(),
            ),
          ),

          //El expanded maneja los descuentos que se muestran
          Expanded(
              child: ListView.builder(
                  itemCount: filterDiscount.length,
                  itemBuilder: (context, index) {
                    final discount = filterDiscount[
                        index]; //nos traemos los descuentos filtrados
                    return Card(
                        //tarjetas con la info del descuento
                        elevation: 8.0,
                        margin: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Colors.indigoAccent),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(discount.buisness_logo)),
                            title: Text(
                                discount
                                    .name, //nombre propio al descuento que nos trajimos
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                discount
                                    .description, //descripcion del descuento que nos trajimos
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic)),
                          ),
                        ));
                  })),

          //Cuadros de los descuentos OJO NO SE SI QUITARLO
          // en este video manejaban un widget de carrusel aparte y lo llamaban arriba.
          // ademas tenian una carpeta de lo que se pasaba a los cuadros y se llamaba
          /*Padding(
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
            )*/
        ],
      ),

      //Bottom NavBar
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
