import 'package:unipadonde/main.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/modeldata/categoria_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';

class LandingRepo {
  Future<List<List<dynamic>>> fetchCategorias() async {
    try {
      final data = await supabase.from('categoria').select();
      final List<dynamic> initiallist = data;

      final categorias = initiallist.map((item) {
        final categoria = Categoria.fromMap((item));
        return [categoria.id, categoria.name];
      }).toList();
      return categorias;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
      //throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<Discount>> fetchDiscounts() async {
    try {
      final descuentos =
          await supabase.from('descuento').select().eq('state', true);
      final pertenece = await supabase.from('pertenece').select();
      final info = await supabase.from('negocio').select();
      List<Discount> descuentoslistos = [];
      final negocioMap = {
        for (var n in info) n['id']: Business.fromMap(n),
      };
      final perteneceMap = {
        for (var n in pertenece) n['id_negocio']: n["id_categoria"]
      };

      for (var descuento in descuentos) {
        final idNegocio = descuento['id_negocio'];
        final business = negocioMap[idNegocio];
        descuento['business'] = business;
        descuento['idcategory'] = perteneceMap[idNegocio];
        final item = Discount.fromMap(descuento);
        descuentoslistos.add(item);
      }

      return descuentoslistos;
    } catch (e) {
      print('Error fetching discounts: $e');
      return [];
      //throw Exception('Error fetching discounts: $e');
    }
  }

  Future<void> addSubscription(int userId, String categoryId) async {
    try {
      print(
          'Attempting to add subscription for user $userId and category $categoryId');

      final response = await supabase.from('subscribe').insert({
        'id_usuario': userId,
        'id_categoria': categoryId,
        'date': DateTime.now().toIso8601String(),
        'state': true,
      });

      if (response.error != null) {
        print('Error adding subscription: ${response.error!.message}');
        throw Exception(
            'Failed to add subscription: ${response.error!.message}');
      } else {
        print('Subscription added successfully');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<bool> isSubscribed(int userId, int categoryId) async {
    try {
      final response = await supabase
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
