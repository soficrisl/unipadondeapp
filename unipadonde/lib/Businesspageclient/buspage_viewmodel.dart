import 'package:flutter/foundation.dart';
import 'package:unipadonde/Businesspageclient/buspage_repository.dart';
import 'package:unipadonde/modeldata/adress_model.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/modeldata/comment_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';

class BuspageViewModel extends ChangeNotifier {
  final BuspageRepository _repo = BuspageRepository();
  final int idNegocio;
  final Business business;
  bool _loading = true;
  List<Discount> discounts = [];
  Address address = Address(
      id: 0,
      id_negocio: 0,
      estado: "",
      ciudad: "",
      municipio: "",
      calle: "",
      additional_info: "");
  List<Comment> comments = [];
  int _rating = 0;

  BuspageViewModel({required this.idNegocio, required this.business}) {
    _rating = 0;
  }

  int get rating => _rating;

  bool isLoading() {
    return _loading;
  }

  void setLoading(bool set) {
    _loading = set;
  }

  set rating(int value) {
    _rating = value;
    notifyListeners();
  }

  Future<void> fetchDiscounts() async {
    final response = await _repo.fetchDiscounts(idNegocio, business);
    discounts = response;
    notifyListeners();
  }

  Future<void> fetchAddress() async {
    final response = await _repo.fetchAddress(idNegocio);
    if (response != null) {
      address = response;
    }
    notifyListeners();
  }

  Future<void> fetchComments() async {
    final response = await _repo.fetchComments(idNegocio);
    if (response != null) {
      comments = response;
    }
    notifyListeners();
  }

  Future<void> submitComment(String content, int rating) async {
    await _repo.submitComment(content, rating, idNegocio);
    await fetchComments();
  }
}
