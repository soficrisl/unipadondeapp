import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/Businesspageclient/buspage_view.dart';
import 'package:unipadonde/landingpage/landing_vm.dart';
import 'package:unipadonde/searchbar/Search_view.dart';
import 'package:unipadonde/widgets/bottom_bar.dart';

import 'package:unipadonde/modeldata/discount_model.dart';

class Landing extends StatefulWidget {
  final int userId;
  const Landing({
    super.key,
    required this.userId,
  });

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final LandingViewModel _viewModel = LandingViewModel();
  bool showSubscribeButton = false;
  List<List<dynamic>> categories = [];
  List<Discount> listofdiscounts = [];

  void getcat() async {
    await _viewModel.fetchCategorias();
    setState(() {
      categories = _viewModel.getCategorias() ?? [];
    });
  }

  void getdis() async {
    await _viewModel.fetchDiscounts();
    if (mounted) {
      setState(() {
        listofdiscounts = _viewModel.getDescuentos() ?? [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getcat();
    getdis();
  }

  List<int> selectedCategories = [];
  int _selectedIndex = 0;

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
      case 3:
        Navigator.pushReplacementNamed(context, '/search',
            arguments: widget.userId);
        break;
    }
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void subscribeToCategories() async {
    // Crear una copia de la lista para evitar la modificación concurrente
    final List<int> categoriesToSubscribe = List.from(selectedCategories);
    for (int categoryId in categoriesToSubscribe) {
      // Iterar sobre la copia
      bool isAlreadySubscribed =
          await _viewModel.isSubscribed(widget.userId, categoryId);
      if (!isAlreadySubscribed) {
        await _viewModel.addSubscription(widget.userId, categoryId.toString());
      }
    }
    setState(() {
      showSubscribeButton = false;
      selectedCategories
          .clear(); // Limpiar la lista original después de la iteración
    });
  }

  void updateSubscribeButtonVisibility() async {
    bool hasNewCategories = false;

    for (int categoryId in selectedCategories) {
      bool isAlreadySubscribed =
          await _viewModel.isSubscribed(widget.userId, categoryId);
      if (!isAlreadySubscribed) {
        hasNewCategories = true;
        break;
      }
    }

    setState(() {
      showSubscribeButton = hasNewCategories;
    });
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
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
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
                colors: [
                  const Color(0xFF8CB1F1),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index][1];
                      final idcategory = categories[index][0];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                          onSelected: (selected) async {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(idcategory);
                              } else {
                                selectedCategories.remove(idcategory);
                              }
                            });
                            updateSubscribeButtonVisibility();
                          },
                          backgroundColor:
                              selectedCategories.contains(idcategory)
                                  ? const Color(0xFFFFA500)
                                  : Color(0xFFFFFFFF),
                          selectedColor: const Color(0xFFFFA500),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: selectedCategories.contains(idcategory)
                                ? const Color(0xFFFFA500)
                                : const Color(0xFFFFA500),
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
                Expanded(
                  child: ListView.builder(
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
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            leading: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                image: DecorationImage(
                                  image: discount.business.imageurl.isNotEmpty
                                      ? NetworkImage(discount.business
                                          .imageurl) // Network image if URL is available
                                      : AssetImage(discount.business.picture)
                                          as ImageProvider,
                                  fit: BoxFit.cover,
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
                CustomBottomBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _navigateToPage(index);
                  },
                ),
              ],
            ),
          ),
          if (showSubscribeButton)
            Positioned(
              bottom: 90.0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: subscribeToCategories,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8CB1F1),
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
                  child: Text("Suscribirse a categoría"),
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
                  discount.business.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  discount.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  discount.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Duración: ARREGLAR",
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
