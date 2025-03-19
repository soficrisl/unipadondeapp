import 'package:unipadonde/main.dart';
import 'package:unipadonde/modeldata/business_model.dart';

class BuspageProvRepo {
  Future<Business?> updateBusiness(String name, String description,
      String tiktok, String instagram, String webpage, int businessId) async {
    try {
      await supabase.from('negocio').update({
        'name': name,
        'description': description,
        'tiktok': tiktok,
        'instagram': instagram,
        'webpage': webpage,
      }).eq('id', businessId);

      final data =
          await supabase.from('negocio').select().eq('id', businessId).single();
      final user = Business.fromMap(data);
      return user;
    } catch (e) {
      throw Exception("Error updating business: $name");
    }
  }
}
