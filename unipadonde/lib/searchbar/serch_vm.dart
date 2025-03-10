import 'package:unipadonde/searchbar/search_model.dart';

class SearchVm {
  List<Business> businessList = [];
  final SearchModel model = SearchModel();
  bool _isInitialized = false;

  Future<void> fetch() async {
    if (!_isInitialized) {
      businessList = await model.getBusiness();
      print('VIEWMODEL');
      print(businessList);
      _isInitialized = true;
    }
  }

  List<Business> getList() {
    return businessList;
  }

  Future<void> suggestion(String text) async {
    print(3);
    await model.insertSuggestion(text);
  }
}
