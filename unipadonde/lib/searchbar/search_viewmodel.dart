import 'package:flutter/foundation.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/searchbar/search_repo.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepo _repo = SearchRepo();
  List<Business> businessList = [];

  SearchViewModel() {
    fechtBusiness();
  }

  Future<void> fechtBusiness() async {
    try {
      businessList = await _repo.fechtBusiness();
    } on Exception catch (error) {
      throw Exception('Error fetching business: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<String> submitSuggestion(String text) async {
    try {
      final response = await _repo.submitSuggestion(text);
      return response;
    } catch (e) {
      return 'Error submitting comment: $e';
    }
  }
}
