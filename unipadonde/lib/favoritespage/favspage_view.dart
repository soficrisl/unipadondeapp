import 'package:flutter/material.dart';
import 'package:unipadonde/favoritespage/favspage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/widgets/bottom_bar.dart';
import 'package:unipadonde/business%20page/buspage_view.dart'; // Importa BuspageView

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

  final dataService = DataService(Supabase.instance.client);

  void getcat() async {
  await dataService.fetchCategoriasSuscritas(widget.userId);
  setState(() {
    categories = dataService.getCategoriasSuscritas();
  });
  getdis();
}

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

  // Método para eliminar la suscripción a una categoría
  void unsubscribeFromCategories() async {
    final dataService = DataService(Supabase.instance.client);
    for (int categoryId in selectedCategories) {
      await dataService.removeSubscription(widget.userId, categoryId.toString());
    }
    setState(() {
      selectedCategories.clear(); // Limpiar las categorías seleccionadas
      showUnsubscribeButton = false; // Ocultar el botón después de eliminar la suscripción
    });
    getcat(); // Recargar las categorías suscritas
  }

  @override
  Widget build(BuildContext context) {
    final filterDiscount = listofdiscounts.where((discount) {
      return selectedCategories.isEmpty || selectedCategories.contains(discount.idcategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
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
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
              _navigateToPage(3);
            },
          ),
          IconButton(
              onPressed: logout, icon: const Icon(Icons.logout, color: Colors.black)),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                                color: selectedCategories.contains(category.id)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedCategories.add(category.id);
                                  showUnsubscribeButton = true; // Mostrar el botón
                                } else {
                                  selectedCategories.remove(category.id);
                                  showUnsubscribeButton = selectedCategories.isNotEmpty; // Ocultar si no hay selecciones
                                }
                              });
                            },
                            backgroundColor: selectedCategories.contains(category.id)
                                ? Color(0xFFFFA500)
                                : Color(0xFFFFFFFF),
                            selectedColor: Color(0xFFFFA500),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(
                              color: selectedCategories.contains(category.id)
                                  ? Color(0xFFFFA500)
                                  : Color(0xFFFFA500),
                              width: 2.0,
                            ),
                            elevation: 5.0,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  onPressed: unsubscribeFromCategories, // Llamar al método para eliminar suscripción
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
            child: ClipOval(
              child: Image.asset(
                discount.businessLogo,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            discount.businessName, // Nombre del negocio
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
            "Duración: ${discount.duration}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BuspageView(
                    businessName: discount.businessName, // Nombre del negocio
                    businessDescription: discount.businessDescription, // Descripción del negocio
                    businessTiktok: discount.tiktok ?? 'No disponible',
                    businessInstagram: discount.instagram ?? 'No disponible',
                    businessWebsite: discount.webpage ?? 'No disponible',
                    businessLogo: discount.businessLogo,
                    idNegocio: discount.idbusiness, // Pasar el idNegocio
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