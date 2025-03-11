import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';

class DiscountViewModel {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<int?> addDiscount(Discount discount) async {
    try {
      await supabase.from('descuento').insert(discount.toMap());
      final jsonId = await supabase
          .from('descuento')
          .select('id')
          .order('id', ascending: false)
          .limit(1);
      int idDisc = 0;

      for (var d in jsonId) {
        idDisc = d['id'];
      }
      return idDisc;
    } catch (e) {
      print("Error inesperado: $e");
    }
  }

  Future<int?> updateDiscount(int id, Discount updatedDiscount) async {
    try {
      await supabase
          .from('descuento')
          .update(updatedDiscount.toMap())
          .eq('id', id);

      final jsonId = await supabase.from('descuento').select('id').eq('id', id);
      int idDisc = 0;

      for (var d in jsonId) {
        idDisc = d['id'];
      }

      return idDisc;
    } catch (e) {
      print("Error al actualizar el descuento: $e");
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
