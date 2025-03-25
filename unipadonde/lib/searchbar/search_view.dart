import 'package:flutter/material.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/searchbar/search_viewmodel.dart';

import '../businesspageClient/buspage_view.dart';

//handle search
class CustomSearchDelegate extends SearchDelegate {
  final SearchViewModel _viewModel = SearchViewModel();
  bool _isDataFetched = false;

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

  Future<String> manageSuggestion(
      String suggestion, SearchViewModel viewModel) async {
    try {
      final response = viewModel.submitSuggestion(suggestion);
      return response;
    } catch (e) {
      return "Error Managing suggestion: $e";
    }
  }

  //handle results
  Widget _buildSearchResults(BuildContext context) {
    if (!_isDataFetched) {
      _viewModel.fechtBusiness();
      _isDataFetched = true;
    }
    if (query.isEmpty) {
      return Container(
          color: Colors.white,
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  const Color(0xFFFFA500), // Naranja
                  const Color(0xFF7A9BBF), // Azul
                  const Color(0xFF8CB1F1), // Azul claro
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'UniPaDonde', // Título
                style: TextStyle(
                  color: Colors.white, // El color del texto debe ser blanco
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'San Francisco',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ));
    } else {
      List<Business> matchQuery = _viewModel.businessList
          .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return Container(
          color: Colors.white,
          child: matchQuery.isEmpty
              ? _buildNoResults(context, _viewModel)
              : ListView.builder(
                  itemCount: matchQuery.length,
                  itemBuilder: (context, index) {
                    final bus = matchQuery[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: bus.imageurl.isNotEmpty
                            ? Image.network(
                                bus.imageurl,
                                width: 50,
                                height: 50,
                                fit: BoxFit
                                    .cover, // Ensures the image covers the space fully
                              )
                            : Image.asset(
                                bus.picture,
                                width: 50,
                                height: 50,
                                fit: BoxFit
                                    .cover, // Keeps the same scaling behavior
                              ),
                      ),
                      title: Text(bus.name),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BuspageView(
                            idNegocio: bus.id,
                            business: bus,
                          ),
                        ));
                      },
                    );
                  },
                ));
    }
  }

  //No results
  Widget _buildNoResults(BuildContext context, SearchViewModel viewModel) {
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
                    await manageSuggestion(suggestion, viewModel);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("¡Gracias por tu sugerencia!"),
                        duration: Duration(seconds: 3),
                      ),
                    );
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
