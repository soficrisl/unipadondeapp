import 'package:supabase_flutter/supabase_flutter.dart';

class DataService {
  final SupabaseClient client;
  List<Categoria> categoriasSuscritas = [];
  List<Discount> listofdiscounts = [];

  DataService(this.client);

  Future<void> fetchCategoriasSuscritas(int userId) async {
    try {
      final data = await client
          .from('subscribe')
          .select('id_categoria, categoria(id, name, description)')
          .eq('id_usuario', userId);

      final List<dynamic> initiallist = data;

      categoriasSuscritas = initiallist.map<Categoria>((item) {
        return Categoria.fromMap(item['categoria']);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching subscribed categories: $e');
    }
  }

  List<Categoria> getCategoriasSuscritas() {
    return categoriasSuscritas;
  }

  Future<void> fetchDiscounts() async {
    try {
      final List<int> subscribedCategoryIds =
          getCategoriasSuscritas().map((c) => c.id).toList();
      final descuentos = await client.from('descuento').select();
      final pertenece = await client.from('pertenece').select();
      final info = await client.from('negocio').select('id, picture');

      List<Map<String, dynamic>> descuentoslistos = [];
      final negocioMap = {for (var n in info) n['id']: n['picture']};
      final perteneceMap = {
        for (var n in pertenece) n['id_negocio']: n["id_categoria"]
      };

      int? idcat;
      String? imagen;
      int? idnegocio;
      for (var descuento in descuentos) {
        idnegocio = descuento['id_negocio'];
        idcat = perteneceMap[idnegocio];
        if (subscribedCategoryIds.contains(idcat)) {
          imagen = negocioMap[idnegocio];
          descuento['businessLogo'] = imagen;
          descuento['idcategory'] = idcat;
          descuentoslistos.add(descuento);
        }
      }
      listofdiscounts =
          descuentoslistos.map((json) => Discount.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching discounts');
    }
  }

  List<Discount>? getDescuentos() {
    return listofdiscounts;
  }
}

//Atributos del descuento
class Discount {
  final int id;
  final String name;
  final String description;
  final int porcentaje;
  final String businessLogo;
  final String duration;
  final int idcategory;
  final int idbusiness;

  Discount({
    required this.id,
    required this.name,
    required this.idcategory,
    required this.businessLogo,
    required this.description,
    required this.duration,
    required this.idbusiness,
    required this.porcentaje,
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
    );
  }
}

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

class Pertenece {
  final int business;
  final int category;

  Pertenece({
    required this.business,
    required this.category,
  });
}

class Negocio {
  final int id;
  final String description;
  final String tiktok;
  final String instagram;
  final String name;
  final String mail;
  final String webpage;

  Negocio({
    required this.id,
    required this.name,
    required this.description,
    required this.tiktok,
    required this.instagram,
    required this.webpage,
    required this.mail,
  });
}
