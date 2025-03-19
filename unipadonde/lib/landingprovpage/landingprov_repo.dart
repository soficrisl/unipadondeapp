import 'package:unipadonde/main.dart';
import 'package:unipadonde/modeldata/business_model.dart';

class LandingProvRepo {
  Future<List<Business>> fetchBusinesses(int idproveedor) async {
    try {
      final response = await supabase
          .from('negocio')
          .select('*')
          .eq('id_proveedor', idproveedor);

      List<Business> business =
          response.map((data) => Business.fromMap(data)).toList();
      return business;
    } catch (e) {
      throw Exception('error uploading business $e');
    }
  }

  Future<Business?> addBusiness(Map<String, dynamic> json) async {
    try {
      await supabase.from('negocio').insert(json);
      final id = int.parse(json['id'] as String);
      final response = await supabase.from('negocio').select().eq('id', id);
      final jsonnew = response[0];
      final newBusiness = Business.fromMap(jsonnew);
      return newBusiness;
    } catch (e) {
      throw Exception('Error adding business $e');
    }
  }
}
