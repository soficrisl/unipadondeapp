import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/favoritespage/favspage_vm.dart';
import 'package:unipadonde/modeldata/categoria_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';
import 'package:unipadonde/validations.dart';
import 'package:unipadonde/widgets/bottom_bar.dart'; // Importa BuspageView
import 'package:unipadonde/Businesspageclient/buspage_view.dart';

class Favspage extends StatefulWidget {
  final int userId;
  const Favspage({required this.userId, super.key});

  @override
  State<Favspage> createState() => _FavspageState();
}

class _FavspageState extends State<Favspage> {
  List<Categoria> categories = [];
  List<Discount> listofdiscounts = [];
  List<int> selectedCategories = [];
  bool showUnsubscribeButton = false; // Nuevo estado para mostrar el botón
  int _selectedIndex = 1;
  bool isLoading = false;
  final _viewmodel = FavspageViewModel();

  void getcat() async {
    await _viewmodel.fetchCategoriasSuscritas();
    if (mounted) {
      setState(() {
        categories = _viewmodel.getCategoriasSuscritas();
      });
    }
    getdis();
  }

  void getdis() async {
    await _viewmodel.fetchDiscounts();
    setState(() {
      if (mounted) {
        listofdiscounts = _viewmodel.getDescuentos() ?? [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getcat();
    getdis();
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/start');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/landing',
            arguments: widget.userId);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/favorites',
            arguments: widget.userId);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile',
            arguments: widget.userId);
        break;
    }
  }

  // Método para eliminar la suscripción a una categoría
  void unsubscribeFromCategories() async {
    for (int categoryId in selectedCategories) {
      await _viewmodel.removeSubscription(categoryId, categories);
    }
    setState(() {
      selectedCategories.clear(); // Limpiar las categorías seleccionadas
      showUnsubscribeButton =
          false; // Ocultar el botón después de eliminar la suscripción
    });
    getcat(); // Recargar las categorías suscritas
  }

  @override
  Widget build(BuildContext context) {
    final filterDiscount = listofdiscounts.where((discount) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(discount.idcategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFFFFA500),
              const Color(0xFF7A9BBF),
              const Color(0xFF8CB1F1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Mis Categorías",
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
              onPressed: logout,
              icon: const Icon(Icons.logout, color: Colors.black)),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 72, 128, 188), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned.fill(
            top: 0,
            bottom: 60,
            child: (categories.isEmpty)
                ? Center(
                    child: Text(
                      'Subscribete\n a una\n categoria',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'San Francisco',
                          color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  selected:
                                      selectedCategories.contains(category.id),
                                  label: Text(
                                    category.name,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'San Francisco',
                                      color: selectedCategories
                                              .contains(category.id)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedCategories.add(category.id);
                                        showUnsubscribeButton =
                                            true; // Mostrar el botón
                                      } else {
                                        selectedCategories.remove(category.id);
                                        showUnsubscribeButton = selectedCategories
                                            .isNotEmpty; // Ocultar si no hay selecciones
                                      }
                                    });
                                  },
                                  backgroundColor:
                                      selectedCategories.contains(category.id)
                                          ? Color(0xFFFFA500)
                                          : Color(0xFFFFFFFF),
                                  selectedColor: Color(0xFFFFA500),
                                  checkmarkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: BorderSide(
                                    color:
                                        selectedCategories.contains(category.id)
                                            ? Color(0xFFFFA500)
                                            : Color(0xFFFFA500),
                                    width: 2.0,
                                  ),
                                  elevation: 5.0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                ),
                              );
                            },
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filterDiscount.length,
                          itemBuilder: (context, index) {
                            final discount = filterDiscount[index];
                            return Card(
                              elevation: 4.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                                        image: discount
                                                .business.imageurl.isNotEmpty
                                            ? NetworkImage(discount.business
                                                .imageurl) // Network image if URL is available
                                            : AssetImage(
                                                    discount.business.picture)
                                                as ImageProvider, // Local asset as fallback,
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
                                  onTap: () {
                                    openDialog(discount);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _navigateToPage(index);
              },
            ),
          ),
          if (showUnsubscribeButton) // Mostrar el botón si hay categorías seleccionadas
            Positioned(
              bottom: 90.0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed:
                      unsubscribeFromCategories, // Llamar al método para eliminar suscripción
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA500), // Color naranja
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Eliminar suscripción"),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: discount.business.imageurl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            discount.business.imageurl,
                            fit: BoxFit
                                .contain, // Matches the behavior of Image.asset
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            discount.business.picture,
                            fit: BoxFit.contain, // Keeps the style consistent
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Text(
                  discount.business.name, // Nombre del negocio
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  discount.name, // Nombre del descuento
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  discount.description, // Descripción del descuento
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Válido desde: ${Validations.formatDate(discount.startdate)}",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "San Francisco",
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "hasta: ${Validations.formatDate(discount.enddate)} ",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "San Francisco",
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BuspageView(
                          idNegocio: discount.idnegocio,
                          business: discount.business,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA500),
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
