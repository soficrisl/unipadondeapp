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
    return _buildSearchResults();
  }

  //handle suggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  //handle results
  Widget _buildSearchResults() {
    List<Buisness> matchQuery = allBuisness
        .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
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
    );
  }
}
