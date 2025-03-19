import 'package:unipadonde/favoritespage/favspage_repo.dart';
import 'package:unipadonde/modeldata/categoria_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';

class FavspageViewModel {
  final FavsPageRepo _repo = FavsPageRepo();
  List<Categoria> categoriasSuscritas = [];
  List<Discount> listofdiscounts = [];

  Future<void> fetchCategoriasSuscritas() async {
    try {
      categoriasSuscritas = await _repo.fetchCategoriasSuscritas();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  List<Categoria> getCategoriasSuscritas() {
    return categoriasSuscritas;
  }

  Future<void> fetchDiscounts() async {
    try {
      listofdiscounts = await _repo.fetchDiscounts(categoriasSuscritas);
    } catch (e) {
      throw Exception('Error fetching discounts: $e');
    }
  }

  List<Discount>? getDescuentos() {
    return listofdiscounts;
  }

  Future<void> removeSubscription(
      int categoryId, List<Categoria> listcategory) async {
    try {
      categoriasSuscritas =
          await _repo.removeSubscription(categoryId, listcategory);
      fetchDiscounts();
    } catch (e) {
      throw Exception('Exception caught: $e');
    }
  }
}
