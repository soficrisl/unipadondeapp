import 'package:flutter/material.dart';
import 'package:unipadonde/businessprovinfo/business_info_repo.dart';
import 'package:unipadonde/modeldata/adress_model.dart';
import 'package:unipadonde/modeldata/business_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';

class BusinessInfoViewModel extends ChangeNotifier {
  final BusinessInfoRepo _repo = BusinessInfoRepo();
  List<Discount> discounts = [];
  Address address = Address(
      id: 0,
      id_negocio: 0,
      estado: "",
      ciudad: "",
      municipio: "",
      calle: "",
      additional_info: "");
  final int idNegocio;
  Business business;
  bool _loading = true;
  BusinessInfoViewModel({required this.idNegocio, required this.business});

  bool isLoading() {
    return _loading;
  }

  void setLoading(bool set) {
    _loading = set;
  }

  Future<void> fetchDiscounts() async {
    final response = await _repo.fetchDiscounts(idNegocio, business);
    discounts = response;
    notifyListeners();
  }

  Future<void> getUpdatedBusiness() async {
    final response = await _repo.getUpdatedBusiness(idNegocio);
    if (response != null) {
      business = response;
    }
  }

  Future<void> fetchAddress() async {
    final response = await _repo.fetchAddress(business.id);
    if (response != null) {
      address = response;
    }
    notifyListeners();
  }

  Future<bool> deleteBusiness() async {
    final response = await _repo.deleteBusiness(business.id);
    return response;
  }

  Future<bool> addDiscount(Map<String, dynamic> discount) async {
    final newDiscount = await _repo.addDiscount(discount);
    if (newDiscount != null) {
      discounts.add(newDiscount);
      return true;
    }
    return false;
  }

  Future<bool> updateDiscount(
      int discountId, Map<String, dynamic> discount) async {
    final newDiscount = await _repo.updateDiscount(discountId, discount);
    if (newDiscount != null) {
      int index = discounts.indexWhere((d) => d.id == discountId);
      discounts[index] = newDiscount;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteDiscount(int discountId) async {
    final response = await _repo.deleteDiscount(discountId);
    try {
      if (response) {
        discounts.removeWhere((d) => d.id == discountId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error deleting discount $e');
    }
  }
}
