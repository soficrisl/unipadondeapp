import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/business%20page/buspage_view.dart';
import 'package:unipadonde/businessprovinfo/business_info_view.dart';
import 'package:unipadonde/searchbar/search_model.dart';
import 'package:unipadonde/searchbar/serch_vm.dart';
import 'package:unipadonde/main.dart';

//handle search
class CustomSearchDelegate extends SearchDelegate {
  final SearchVm vm = SearchVm();

  //campo busqueda
  @override
  String get searchFieldLabel => 'Buscar negocios...';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontFamily: 'San Francisco',
        fontSize: 16,
        color: Colors.black54,
      );

  //clear
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  //exit search
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  //handle suggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Future<void> manageSuggestion(String suggestion) async {
    print('2');
    await vm.suggestion(suggestion);
  }

  //handle results
  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder(
      future: vm.fetch(), // Wait for data to be fetched
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Business> allBusiness = vm.getList();
          print('view');
          print(allBusiness);
          List<Business> matchQuery = allBusiness
              .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
          print(matchQuery);
          return Container(
            color: Colors.white,
            child: matchQuery.isEmpty
                ? _buildNoResults(context)
                : ListView.builder(
                    itemCount: matchQuery.length,
                    itemBuilder: (context, index) {
                      final business = matchQuery[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(business.picture,
                              width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        title: Text(business.name),
                        onTap: () {
                          print('Tapped on ${business.name}');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BuspageView(
                                    idNegocio: business.id,
                                    businessName: business.name,
                                    businessDescription: business.description,
                                    businessInstagram: business.instagram,
                                    businessLogo: business.picture,
                                    businessTiktok: business.tiktok,
                                    businessWebsite: business.webpage)),
                          );
                        },
                      );
                    },
                  ),
          );
        }
      },
    );
  }

  //No results
  Widget _buildNoResults(BuildContext context) {
    final TextEditingController suggestionController = TextEditingController();

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //icon and message
              const Icon(Icons.search_off, size: 70, color: Color(0xFFFFA500)),
              const SizedBox(height: 5),
              const Text(
                "Negocio no encontrado",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA500),
                ),
              ),

              //add message
              const SizedBox(height: 30),
              const Text(
                "Cuéntanos qué te gustaría que agreguemos al sitio:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              //text input
              const SizedBox(height: 20),
              TextField(
                controller: suggestionController,
                decoration: InputDecoration(
                  hintText: "Escribe tu sugerencia aquí...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),

              //send and pop-up
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final suggestion = suggestionController.text.trim();
                  if (suggestion.isNotEmpty) {
                    await manageSuggestion(suggestion);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("¡Gracias por tu sugerencia!"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    suggestionController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Ingresa datos, por favor."),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8CB1F1),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("Enviar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
