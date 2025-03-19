import 'package:unipadonde/main.dart';
import 'package:unipadonde/modeldata/categoria_model.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';

class FavsPageRepo {
  Future<List<Categoria>> fetchCategoriasSuscritas() async {
    final uid = supabase.auth.currentUser?.id ?? "";
    final response = await supabase.from('usuario').select('id').eq('uid', uid);
    final userId = response[0]['id'];
    try {
      final data = await supabase
          .from('subscribe')
          .select('id_categoria, categoria(id, name, description)')
          .eq('id_usuario', userId)
          .eq('state', true); // Solo obtener las categorías con state TRUE
      List<Categoria> categoriasSuscritas = [];
      categoriasSuscritas = data.map<Categoria>((item) {
        return Categoria.fromMap(item['categoria']);
      }).toList();
      return categoriasSuscritas;
    } catch (e) {
      return [];
      //throw Exception('Error fetching subscribed categories: $e');
    }
  }

  Future<List<Discount>> fetchDiscounts(List<Categoria> listcategory) async {
    try {
      final List<int> subscribedCategoryIds =
          listcategory.map((c) => c.id).toList();
      final descuentos =
          await supabase.from('descuento').select().eq('state', true);
      final pertenece = await supabase.from('pertenece').select(
          'id_categoria, id_negocio, negocio(id, name, description, picture, tiktok, mail, instagram, webpage, id_proveedor)');

      final filteredPertenece = pertenece
          .where((item) => subscribedCategoryIds.contains(item['id_categoria']))
          .toList();

      final List<int> businessIds =
          filteredPertenece.map((item) => item['id_negocio'] as int).toList();

      final filterediscounts = descuentos
          .where((item) => businessIds.contains(item['id_negocio']))
          .toList();

      final perteneceMap = {
        for (var item in filteredPertenece) item['id_negocio']: item
      };

      List<Discount> descuentoslistos = [];
      for (var discount in filterediscounts) {
        discount['idcategory'] =
            perteneceMap[discount['id_negocio']]?['id_categoria'];
        discount['business'] =
            Business.fromMap(perteneceMap[discount['id_negocio']]?['negocio']);
        final dis = Discount.fromMap(discount);
        descuentoslistos.add(dis);
      }

      return descuentoslistos;
    } catch (e) {
      print(
          'Error fetching discounts: $e'); // Imprimir el error para depuración
      throw Exception(
          'Error fetching discounts: $e'); // Lanzar la excepción con el mensaje de error
    }
  }

  Future<List<Categoria>> removeSubscription(
      int categoryId, List<Categoria> listcategory) async {
    final uid = supabase.auth.currentUser?.id ?? "";
    final response = await supabase.from('usuario').select('id').eq('uid', uid);
    final userId = response[0]['id'];
    try {
      await supabase
          .from('subscribe')
          .delete()
          .eq('id_usuario', userId)
          .eq('id_categoria', categoryId);
      listcategory.removeWhere((cat) => cat.id == categoryId);
      return listcategory;
    } catch (e) {
      throw Exception('Error removing subscription: $e');
    }
  }
}
