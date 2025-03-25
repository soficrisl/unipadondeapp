import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/main.dart';

class SearchRepo {
  Future<List<Business>> fechtBusiness() async {
    try {
      final data = await supabase.from('negocio').select();
      final List<dynamic> dataList = data;
      final businessList = dataList.map((item) {
        return Business.fromMap((item));
      }).toList();
      return businessList;
    } on Exception catch (error) {
      print('Error fetching business: $error');
      return [];
    }
  }

  Future<String> submitSuggestion(String text) async {
    try {
      await supabase.from('sugerencia').insert({'suggestion': text});
      return "";
    } catch (e) {
      return 'Error submitting comment: $e';
    }
  }
}
