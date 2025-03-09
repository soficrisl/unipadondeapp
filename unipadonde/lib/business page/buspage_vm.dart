import 'package:flutter/material.dart';
import 'buspage_model.dart';

class BuspageViewModel with ChangeNotifier {
  final BuspageModel _model = BuspageModel();
  List<Map<String, dynamic>> discounts = [];
  Map<String, dynamic>? address;
  bool isLoading = true;
  List<Map<String, dynamic>> comments = [];
  int _rating = 0;

  int get rating => _rating;

  set rating(int value) {
    _rating = value;
    notifyListeners();
  }

  Future<void> fetchDiscounts(int idNegocio) async {
    discounts = await _model.fetchDiscounts(idNegocio);
    notifyListeners();
  }

  Future<void> fetchAddress(int idNegocio) async {
    address = await _model.fetchAddress(idNegocio);
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchComments(int idNegocio) async {
    comments = await _model.fetchComments(idNegocio);
    notifyListeners();
  }

  Future<void> submitComment(int idNegocio, int estudianteId, String content, int rating) async {
    await _model.submitComment(idNegocio, estudianteId, content, rating);
    await fetchComments(idNegocio);
  }
}