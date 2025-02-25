import 'package:flutter/material.dart';
import 'package:unipadonde/searchbar/search_model.dart';

//handle search
class CustomSearchDelegate extends SearchDelegate {
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

  //handle results
  Widget _buildSearchResults(BuildContext context) {
    List<Buisness> matchQuery = allBuisness
        .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.white,
      child: matchQuery.isEmpty
          ? _buildNoResults(context)
          : ListView.builder(
              itemCount: matchQuery.length,
              itemBuilder: (context, index) {
                final business = matchQuery[index];
                return ListTile(
                  leading: Image.asset(business.buisnessLogo,
                      width: 50, height: 50, fit: BoxFit.contain),
                  title: Text(business.name),
                  /*onTap: () {
                  close(context, null); // Cierra la búsqueda
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessDetailScreen(business: business),
                    ),
                  );*/
                );
              },
            ),
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
                onPressed: () {
                  final suggestion = suggestionController.text.trim();
                  if (suggestion.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("¡Gracias por tu sugerencia!"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    suggestionController.clear();
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
