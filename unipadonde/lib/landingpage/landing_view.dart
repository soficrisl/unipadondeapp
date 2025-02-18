import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:unipadonde/landingpage/landin_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  //lista de categorias
  List<List<dynamic>> categories = [];
  List<Discount> listofdiscounts = [];

  void getcat() async {
    /// Esto deberia estar en el VM
    final dataService = DataService(Supabase.instance.client);
    await dataService.fetchCategorias();
    setState(() {
      categories = dataService.getCategorias() ?? [];
    });
  }

  void getdis() async {
    // Esto deberia estar en el VM
    final dataService = DataService(Supabase.instance.client);
    await dataService.fetchDiscounts();
    setState(() {
      listofdiscounts = dataService.getDescuentos() ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getcat();
    getdis();
  }

  //categorias seleccionadas
  List<int> selectedCategories = [];

  // Función de logout
  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login'); // Redirige a login
    }
  }

  @override
  Widget build(BuildContext context) {
    //filtrar los descuentos de acuerdo a la categoria seleccionada
    final filterDiscount = listofdiscounts.where((discount) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(discount.idcategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        //appBar con nombre de la app y profile
        toolbarHeight: 90,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFFFAAF90),
              const Color(0xFF8CB1F1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "UnipaDonde",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
            ),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 12),
              width: 40,
              height: 40,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Image.asset("assets/images/profile.png",
                  fit: BoxFit.contain)),
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout, color: Colors.black)),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFAAF90), //fondo principal
              const Color(0xFF8CB1F1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Este container muestra los botones de categorías
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              height: 60, // Ajusta la altura del carrusel
              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal, // Hacemos que se desplace horizontalmente
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index][1];
                  final idcategory = categories[index][0];
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0), // Espaciado entre categorías
                    child: FilterChip(
                      selected: selectedCategories.contains(idcategory),
                      label: Text(
                        category,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'San Francisco',
                          color: selectedCategories.contains(idcategory)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(idcategory);
                          } else {
                            selectedCategories.remove(idcategory);
                          }
                        });
                      },
                      backgroundColor: selectedCategories.contains(idcategory)
                          ? Color(0xFFFAAF90)
                          : Color(0xFFFFFFFF),
                      selectedColor: Color(0xFFFAAF90),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: selectedCategories.contains(idcategory)
                            ? Color(0xFFFAAF90)
                            : Color(0xFFFAAF90),
                        width: 2.0,
                      ),
                      elevation: 5.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  );
                },
              ),
            ),

            // Aqui se maneja la visualización de los descuentos filtrados
            Expanded(
              child: ListView.builder(
                itemCount: filterDiscount.length,
                itemBuilder: (context, index) {
                  final discount = filterDiscount[index];
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                              image: AssetImage(discount.businessLogo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          discount.name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'San Francisco'),
                        ),
                        subtitle: Text(
                          discount.description,
                          style: const TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'San Francisco'),
                        ),
                        // Eliminado el ícono de tres puntos (trailing)
                        onTap: () {
                          openDialog(discount);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Este es el bottom bar dentro del container con el degradado
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(69),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FeatherIcons.home,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FeatherIcons.search,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FeatherIcons.heart,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar un pop-up con información del descuento
  Future openDialog(Discount discount) => showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagen y nombre del negocio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(discount.businessLogo),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                                spreadRadius: 3,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            discount.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                fontFamily: 'San Francisco'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Descripción del descuento
                    Text(
                      discount.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'San Francisco',
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    // Duración del descuento
                    Text(
                      "Duración: ${discount.duration}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.redAccent,
                          fontFamily: 'San Francisco'),
                    ),
                    const SizedBox(height: 20),
                    // Botón "Ir al negocio"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFfcc9b5), // Color de fondo del botón
                        foregroundColor: Colors.black, //Color texto en el boton
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'San Francisco'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Visitar negocio"),
                    ),
                  ],
                ),
                // Botón X para cerrar el diálogo
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
