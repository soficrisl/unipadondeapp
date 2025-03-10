import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';

class DiscountViewModel {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> addDiscount(Discount discount) async {
    try {
      await supabase.from('descuento').insert(discount.toMap());
      return true;
    } catch (e) {
      print("Error inesperado: $e");
      return false;
    }
  }

  Future<bool> updateDiscount(int id, Discount updatedDiscount) async {
    try {
      await supabase
          .from('descuento')
          .update(updatedDiscount.toMap())
          .eq('id', id);
      return true;
    } catch (e) {
      print("Error al actualizar el descuento: $e");
      return false;
    }
  }

  Future<bool> deleteDiscount(int discountId) async {
    try {
      final response =
          await supabase.from('descuento').delete().eq('id', discountId);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error al eliminar el descuento: $e");
      return false;
    }
  }
}
