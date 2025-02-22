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
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
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
                    elevation: 4.0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                              image: AssetImage(discount.businessLogo),
                              fit: BoxFit.contain,
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/landing');
                    },
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
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/favorites',
                      ); //arguments: userID
                    },
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón X para cerrar el diálogo
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Imagen  del negocio
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      discount.businessLogo,
                      fit:
                          BoxFit.contain, // Ajusta la imagen dentro del círculo
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                //Titulo / Nombre de descuento
                Text(
                  discount.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),
                //Descripcion del descuento
                Text(
                  discount.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),
                //duracion descuento
                Text(
                  "Duración: ${discount.duration}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 30),
                //boton negocio
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFFfcc9b5), // Color de fondo del botón
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Visitar negocio"),
                ),
              ],
            ),
          ),
        ),
      );
}
