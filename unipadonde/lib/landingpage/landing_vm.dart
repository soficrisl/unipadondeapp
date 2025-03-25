import 'package:unipadonde/landingpage/landing_repo.dart';
import 'package:unipadonde/modeldata/discount_model.dart';

class LandingViewModel {
  final LandingRepo _repo = LandingRepo();
  List<List<dynamic>> categorias = [];
  List<Discount> listofdiscounts = [];

  Future<void> fetchCategorias() async {
    try {
      categorias = await _repo.fetchCategorias();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  List<List<dynamic>>? getCategorias() {
    return categorias;
  }

  Future<void> fetchDiscounts() async {
    try {
      listofdiscounts = await _repo.fetchDiscounts();
    } catch (e) {
      throw Exception('Error fetching discounts: $e');
    }
  }

  List<Discount>? getDescuentos() {
    return listofdiscounts;
  }

  Future<void> addSubscription(int userId, String categoryId) async {
    try {
      await _repo.addSubscription(userId, categoryId);
    } catch (e) {
      throw Exception('Exception caught: $e');
    }
  }

  Future<bool> isSubscribed(int userId, int categoryId) async {
    try {
      final response = await _repo.isSubscribed(userId, categoryId);
      return response;
    } catch (e) {
      throw Exception('Error checking subscription: $e');
    }
  }
}
