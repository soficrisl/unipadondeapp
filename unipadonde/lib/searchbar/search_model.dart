import 'package:supabase_flutter/supabase_flutter.dart';

class SearchModel {
  final SupabaseClient client = Supabase.instance.client;
  List<Business> business = [];

  Future<void> fetchBusiness() async {
    try {
      final data = await client.from('negocio').select('id, name, picture');
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

  Business({
    required this.id,
    required this.name,
    required this.picture,
  });

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(id: map['id'], name: map['name'], picture: map['picture']);
  }
}
