import 'package:flutter/material.dart';
import 'package:unipadonde/favoritespage/favspage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:unipadonde/business page/buspage_view.dart';

class Favspage extends StatefulWidget {
  final int userId;
  const Favspage({required this.userId, super.key});

  @override
  State<Favspage> createState() => _FavspageState();
}

class _FavspageState extends State<Favspage> {
  // Lista de categorías
  List<Categoria> categories = [];
  List<Discount> listofdiscounts = [];
  List<int> selectedCategories = [];

  final dataService = DataService(Supabase.instance.client); //esto antes estaba dentro de c/funcion y lo saque

  // Cargar categorías suscritas
  void getcat() async {
    await dataService.fetchCategoriasSuscritas(widget.userId);
    setState(() {
      categories = dataService.getCategoriasSuscritas();
    });
    getdis();
  }

  // Cargar descuentos
  void getdis() async {
    await dataService.fetchDiscounts();
    setState(() {
      listofdiscounts = dataService.getDescuentos() ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getcat();
  }

  // Función de logout
  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/start');
    }
  }

  int _selectedIndex = 1;

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/landing', arguments: widget.userId);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/favorites', arguments: widget.userId);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile', arguments: widget.userId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar los descuentos de acuerdo a la categoría seleccionada
    final filterDiscount = listofdiscounts.where((discount) {
      return selectedCategories.isEmpty || selectedCategories.contains(discount.idcategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        // AppBar con nombre de la app y profile
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
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
              _navigateToPage(3);
            },
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFAAF90),
              const Color(0xFF8CB1F1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Mis categorías",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'San Francisco',
              ),
            ),
            // ! Este container muestra los botones de categorías
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: selectedCategories.contains(category.id),
                      label: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'San Francisco',
                          color: selectedCategories.contains(category.id) ? Colors.white : Colors.black,
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category.id);
                          } else {
                            selectedCategories.remove(category.id);
                          }
                        });
                      },
                      backgroundColor: selectedCategories.contains(category.id)
                          ? Color(0xFFFAAF90)
                          : Color(0xFFFFFFFF),
                      selectedColor: Color(0xFFFAAF90),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: selectedCategories.contains(category.id)
                            ? Color(0xFFFAAF90)
                            : Color(0xFFFAAF90),
                        width: 2.0,
                      ),
                      elevation: 5.0,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  );
                },
              ),
            ),

            //! Aquí se maneja la visualización de los descuentos filtrados
            Expanded(
              child: ListView.builder(
                itemCount: filterDiscount.length,
                itemBuilder: (context, index) {
                  final discount = filterDiscount[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            fontFamily: 'San Francisco',
                          ),
                        ),
                        subtitle: Text(
                          discount.description,
                          style: const TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'San Francisco',
                          ),
                        ),
                        onTap: () {
                          openDialog(discount);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToPage(index);
        },
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
                //Titulo | Nombre de descuento
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
                //! BOTON VISITAR NEGOCIO
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BusinessPage()),
                    );
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
