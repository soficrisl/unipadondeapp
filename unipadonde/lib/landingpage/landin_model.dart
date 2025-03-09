import 'package:supabase_flutter/supabase_flutter.dart';

class DataService {
  final SupabaseClient client;
  List<List<dynamic>>? categorias;
  List<Discount> listofdiscounts = [];

  DataService(this.client);

  Future<void> fetchCategorias() async {
    try {
      final data = await client.from('categoria').select();
      final List<dynamic> initiallist = data;

      categorias = initiallist.map((item) {
        final categoria = Categoria.fromMap((item));
        return [categoria.id, categoria.name];
      }).toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  List<List<dynamic>>? getCategorias() {
    return categorias;
  }

  Future<void> fetchDiscounts() async {
    try {
      final descuentos = await client.from('descuento').select();
      final pertenece = await client.from('pertenece').select();
      final info = await client.from('negocio').select('id, name, description, picture, tiktok, instagram, webpage');

      List<Map<String, dynamic>> descuentoslistos = [];
      final negocioMap = {
        for (var n in info) n['id']: {
          'name': n['name'],
          'description': n['description'],
          'picture': n['picture'],
          'tiktok': n['tiktok'],
          'instagram': n['instagram'],
          'webpage': n['webpage'],
        }
      };
      final perteneceMap = {
        for (var n in pertenece) n['id_negocio']: n["id_categoria"]
      };

      int? idcat;
      String? imagen;
      String? tiktok;
      String? instagram;
      String? webpage;
      String? businessName;
      String? businessDescription;
      int? idnegocio;
      for (var descuento in descuentos) {
        idnegocio = descuento['id_negocio'];
        idcat = perteneceMap[idnegocio];
        businessName = negocioMap[idnegocio]?['name'];
        businessDescription = negocioMap[idnegocio]?['description'];
        imagen = negocioMap[idnegocio]?['picture'];
        tiktok = negocioMap[idnegocio]?['tiktok'];
        instagram = negocioMap[idnegocio]?['instagram'];
        webpage = negocioMap[idnegocio]?['webpage'];
        descuento['businessName'] = businessName;
        descuento['businessDescription'] = businessDescription;
        descuento['businessLogo'] = imagen;
        descuento['idcategory'] = idcat;
        descuento['tiktok'] = tiktok;
        descuento['instagram'] = instagram;
        descuento['webpage'] = webpage;
        descuentoslistos.add(descuento);
      }
      listofdiscounts =
          descuentoslistos.map((json) => Discount.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching discounts: $e');
    }
  }

  List<Discount>? getDescuentos() {
    return listofdiscounts;
  }

  Future<void> addSubscription(int userId, String categoryId) async {
    try {
      print('Attempting to add subscription for user $userId and category $categoryId');

      final response = await client.from('subscribe').insert({
        'id_usuario': userId,
        'id_categoria': categoryId,
        'date': DateTime.now().toIso8601String(),
        'state': true,
      });

      if (response.error != null) {
        print('Error adding subscription: ${response.error!.message}');
        throw Exception('Failed to add subscription: ${response.error!.message}');
      } else {
        print('Subscription added successfully');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<bool> isSubscribed(int userId, int categoryId) async {
    try {
      final response = await client
          .from('subscribe')
          .select()
          .eq('id_usuario', userId)
          .eq('id_categoria', categoryId)
          .eq('state', true);

      // Si hay algún registro, el usuario ya está suscrito
      return response.isNotEmpty;
    } catch (e) {
      print('Error checking subscription: $e');
      throw Exception('Error checking subscription: $e');
    }
  }
}

// Definición de la clase Discount
class Discount {
  final int id;
  final String name;
  final String description;
  final int porcentaje;
  final String businessLogo;
  final String duration;
  final int idcategory;
  final int idbusiness;
  final String? tiktok;
  final String? instagram;
  final String? webpage;
  final String businessName;
  final String businessDescription;

  Discount({
    required this.id,
    required this.name,
    required this.idcategory,
    required this.businessLogo,
    required this.description,
    required this.duration,
    required this.idbusiness,
    required this.porcentaje,
    this.tiktok,
    this.instagram,
    this.webpage,
    required this.businessName,
    required this.businessDescription,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      porcentaje: json['porcentaje'],
      businessLogo: json['businessLogo'],
      duration: "Dos dias",
      idcategory: json['idcategory'],
      idbusiness: json['id_negocio'],
      tiktok: json['tiktok'],
      instagram: json['instagram'],
      webpage: json['webpage'],
      businessName: json['businessName'],
      businessDescription: json['businessDescription'],
    );
  }
}

// Definición de la clase Categoria
class Categoria {
  final int id;
  final String name;
  final String description;

  Categoria({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
        id: map['id'], name: map['name'], description: map['description']);
  }
}