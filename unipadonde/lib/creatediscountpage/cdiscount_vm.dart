import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/creatediscountpage/cdiscount_model.dart';

class DiscountViewModel {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> addDiscount(Discount discount) async {
    try {
      await supabase.from('descuento').insert(discount.toMap());
      return true; // Se insertó correctamente
    } catch (e) {
      return false; // Hubo un error
    }
  }
}
