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
        .eq('id_usuario', userId)
        .eq('state', true); // Solo obtener las categorías con state TRUE

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
      if (subscribedCategoryIds.contains(idcat)) {
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
    }
    listofdiscounts =
        descuentoslistos.map((json) => Discount.fromJson(json)).toList();
  } catch (e) {
    print('Error fetching discounts: $e'); // Imprimir el error para depuración
    throw Exception('Error fetching discounts: $e'); // Lanzar la excepción con el mensaje de error
  }
}

  List<Discount>? getDescuentos() {
    return listofdiscounts;
  }

  Future<void> removeSubscription(int userId, String categoryId) async {
    try {
      await client
          .from('subscribe')
          .delete()
          .eq('id_usuario', userId)
          .eq('id_categoria', categoryId);
      categoriasSuscritas.removeWhere((cat) => cat.id.toString() == categoryId);
    } catch (e) {
      throw Exception('Error removing subscription: $e');
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
