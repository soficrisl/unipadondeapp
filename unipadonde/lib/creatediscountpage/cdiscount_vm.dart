import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';

class DiscountViewModel {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> addDiscount(Discount discount) async {
    try {
      await supabase.from('descuento').insert(discount.toMap());
      return true; // Éxito
    } catch (e) {
      print("Error inesperado: $e");
      return false; // Falla
    }
  }
}
