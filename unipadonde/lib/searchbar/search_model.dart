import 'package:supabase_flutter/supabase_flutter.dart';

class SearchModel {
  final SupabaseClient client = Supabase.instance.client;
  List<Business> business = [];

  Future<void> fetchBusiness() async {
    try {
      final data = await client.from('negocio').select();
      final List<dynamic> initiallist = data;
      business = initiallist.map((item) {
        return Business.fromMap((item));
      }).toList();
    } catch (e) {
      throw Exception('Error fetching business');
    }
  }

  Future<List<Business>> getBusiness() async {
    await fetchBusiness();
    return business;
  }

  Future<void> insertSuggestion(String insertdata) async {
    print(insertdata);
    await client.from('sugerencia').insert({'suggestion': insertdata});
  }
}

class Business {
  final int id;
  final String name;
  final String picture;
  final String description;
  final String tiktok;
  final String instagram;
  final String webpage;

  Business({
    required this.id,
    required this.name,
    required this.picture,
    required this.description,
    required this.tiktok,
    required this.instagram,
    required this.webpage,
  });

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      name: map['name'],
      picture: map['picture'],
      description: map['description'],
      tiktok: map['tiktok'] ?? "",
      instagram: map['instagram'] ?? "",
      webpage: map['webpage'] ?? "",
    );
  }
}
