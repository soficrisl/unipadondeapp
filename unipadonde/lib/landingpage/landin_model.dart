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
      final info = await client.from('negocio').select('id, name, description, picture, tiktok, instagram, webpage'); // Añadir campos necesarios

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
        tiktok = negocioMap[idnegocio]?['tiktok']; // Puede ser null
        instagram = negocioMap[idnegocio]?['instagram']; // Puede ser null
        webpage = negocioMap[idnegocio]?['webpage']; // Puede ser null
        descuento['businessName'] = businessName;
        descuento['businessDescription'] = businessDescription;
        descuento['businessLogo'] = imagen;
        descuento['idcategory'] = idcat;
        descuento['tiktok'] = tiktok; // Asignar null si no está presente
        descuento['instagram'] = instagram; // Asignar null si no está presente
        descuento['webpage'] = webpage; // Asignar null si no está presente
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

  // Método para añadir suscripciones
  Future<void> addSubscription(int userId, String categoryId) async {
    try {
      print('Attempting to add subscription for user $userId and category $categoryId');

      final response = await client.from('subscriptions').insert({
        'user_id': userId,
        'category_id': categoryId,
      });

      if (response.error != null) {
        print('Error adding subscription: ${response.error!.message}');
        throw Exception('Failed to add subscription: ${response.error!.message}');
      } else {
        print('Subscription added successfully');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Error adding subscription: $e');
    }
  }
}

// Atributos del descuento
class Discount {
  final int id;
  final String name;
  final String description;
  final int porcentaje;
  final String businessLogo;
  final String duration;
  final int idcategory;
  final int idbusiness;
  final String? tiktok; // Campo opcional
  final String? instagram; // Campo opcional
  final String? webpage; // Campo opcional
  final String businessName; // Nuevo campo
  final String businessDescription; // Nuevo campo

  Discount({
    required this.id,
    required this.name,
    required this.idcategory,
    required this.businessLogo,
    required this.description,
    required this.duration,
    required this.idbusiness,
    required this.porcentaje,
    this.tiktok, // Campo opcional
    this.instagram, // Campo opcional
    this.webpage, // Campo opcional
    required this.businessName, // Nuevo campo
    required this.businessDescription, // Nuevo campo
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
      tiktok: json['tiktok'], // Campo opcional
      instagram: json['instagram'], // Campo opcional
      webpage: json['webpage'], // Campo opcional
      businessName: json['businessName'], // Nuevo campo
      businessDescription: json['businessDescription'], // Nuevo campo
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

// Listamos los descuentos
final List<Discount> listOfDIscounts = [
  /*
  Discount(
    name: "Food Kart",
    category: "Games",
    description: "Ven a jugar GoKarts en 2x1",
    buisnessLogo: "assets/images/fk.png",
    duration: "2 dias",
  ),
  Discount(
    name: "Laser",
    category: "Travel",
    description: "20% descuento en pasajes Ccs-Miami",
    buisnessLogo: "assets/images/laser.png",
    duration: "1 dias",
  ),
  Discount(
    name: "Mykonos",
    category: "Food",
    description: "Por la compra de 3 helados uno gratis",
    buisnessLogo: "assets/images/mykonis.jpg",
    duration: "2 dias",
  ),
  Discount(
    name: "Plan B",
    category: "Food",
    description: "Cheeseburger clasica por tan solo 2 dolares",
    buisnessLogo: "assets/images/planb.png",
    duration: "2 dias",
  ) */
];