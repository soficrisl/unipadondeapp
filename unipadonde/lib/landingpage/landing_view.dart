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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ), // Bordes redondeados del Card
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.indigoAccent,
                              borderRadius: BorderRadius.circular(
                                  15.0)), // Bordes redondeados del fondo),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            leading: Container(
                              width: 80, // Ajusta el tamaño del cuadrado
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados del logo
                                image: DecorationImage(
                                  image: AssetImage(discount.buisnessLogo),
                                  fit: BoxFit
                                      .cover, // Ajusta la imagen dentro del cuadrado
                                ),
                              ),
                            ),
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
                            trailing: Icon(Icons.more_vert),
                            // Para un texto largo ->isThreeLine: true,
                            onTap: () {
                              openDialog(discount);
                            },
                          ),
                        ));
                  })),
        ],
      ),
//list tile -- on tap para mostrar info del negocio
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

  // Método para mostrar el pop-up con información del descuento
  Future openDialog(Discount discount) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          title: Text(
            discount.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                discount.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "Duración: ${discount.duration}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cerrar",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      );
}
