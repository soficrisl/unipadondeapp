import 'package:unipadonde/modeldata/discount_model.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/modeldata/adress_model.dart';
import 'package:unipadonde/main.dart';

class BusinessInfoRepo {
  Future<List<Discount>> fetchDiscounts(int id, Business business) async {
    try {
      final descuentos = await supabase
          .from('descuento')
          .select('*')
          .eq('id_negocio', id)
          .eq('state', true);

      final pertenece = await supabase.from('pertenece').select();
      final perteneceMap = {
        for (var n in pertenece) n['id_negocio']: n["id_categoria"]
      };
      List<Discount> descuentoslistos = [];
      for (var descuento in descuentos) {
        descuento['business'] = business;
        descuento['idcategory'] = perteneceMap[business.id];
        final item = Discount.fromMap(descuento);
        descuentoslistos.add(item);
      }
      return descuentoslistos;
    } catch (e) {
      throw Exception('Error fetching discounts: $e');
    }
  }

  Future<Address?> fetchAddress(int businessId) async {
    try {
      final response = await supabase
          .from('direccion')
          .select('*')
          .eq('id_negocio', businessId);
      final Map<String, dynamic> item = response[0];
      final address = Address.fromMap(item);
      return address;
    } catch (e) {
      print('Error fetching address: $e');
      return null;
    }
  }

  Future<Business?> fetchBusiness(int businessId) async {
    try {
      final response = await supabase
          .from('negocio')
          .select('*')
          .eq('id', businessId)
          .single();
      return Business.fromMap(response);
    } catch (e) {
      throw Exception('Error fetching business: $e');
    }
  }

  Future<bool> deleteBusiness(int businessId) async {
    try {
      await supabase.from('negocio').delete().eq('id', businessId);
      return true;
    } catch (e) {
      //print('Error deleting business: $e');
      return false;
    }
  }

  Future<Discount?> addDiscount(Map<String, dynamic> discount) async {
    try {
      await supabase.from('descuento').insert(discount);
      final json = await supabase
          .from('descuento')
          .select()
          .order('id', ascending: false)
          .limit(1);

      final jsonDiscount = json[0];
      final newdiscount = Discount.fromMap(jsonDiscount);
      return newdiscount;
    } catch (e) {
      throw Exception("Error inesperado: $e");
    }
  }

  Future<Business?> getUpdatedBusiness(int id) async {
    try {
      final response =
          await supabase.from('negocio').select('*').eq('id', id).single();

      final updated = Business.fromMap(response);
      return updated;
    } catch (e) {
      throw Exception('Error refreshing business data: $e');
    }
  }

  Future<Discount?> updateDiscount(
      int id, Map<String, dynamic> updatedDiscount) async {
    try {
      await supabase.from('descuento').update(updatedDiscount).eq('id', id);
      final json = await supabase.from('descuento').select().eq('id', id);
      final jsonDiscount = json[0];
      final newdiscount = Discount.fromMap(jsonDiscount);
      return newdiscount;
    } catch (e) {
      throw Exception("Error al actualizar el descuento: $e");
    }
  }

  Future<bool> deleteDiscount(int discountId) async {
    try {
      await supabase
          .from('descuento')
          .update({'state': false}).eq('id', discountId);
      return true;
    } catch (e) {
      print("Error al eliminar el descuento en Supabase: $e");
      return false;
    }
  }
}
