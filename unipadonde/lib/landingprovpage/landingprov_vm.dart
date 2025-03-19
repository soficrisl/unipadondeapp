import 'package:flutter/material.dart';
import 'package:unipadonde/landingprovpage/landingprov_repo.dart';
import 'package:unipadonde/modeldata/business_model.dart';

class LandingProvVM extends ChangeNotifier {
  final LandingProvRepo _repo = LandingProvRepo();
  final int idproveedor;
  bool _loading = true;
  List<Business> businesses = [];

  LandingProvVM({required this.idproveedor});

  bool isLoading() {
    return _loading;
  }

  void setLoading(bool set) {
    _loading = set;
  }

  Future<void> fetchBusiness() async {
    _loading = true;
    final response = await _repo.fetchBusinesses(idproveedor);
    businesses = response;
    _loading = false;
    notifyListeners();
  }

  Future<bool> addBusiness(Map<String, dynamic> json) async {
    _loading = true;
    final response = await _repo.addBusiness(json);
    if (response != null) {
      businesses.add(response);
      _loading = false;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
