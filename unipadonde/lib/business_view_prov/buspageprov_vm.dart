import 'package:flutter/material.dart';
import 'package:unipadonde/business_view_prov/buspageprov_repo.dart';
import 'package:unipadonde/modeldata/business_model.dart';

class BuspageProvViewModel extends ChangeNotifier {
  Business business;
  bool _updated = true;
  final BuspageProvRepo _repo = BuspageProvRepo();

  BuspageProvViewModel({required this.business});

  Future<bool> updateBusiness(String name, String description, String tiktok,
      String instagram, String webpage, int businessId) async {
    try {
      final response = await _repo.updateBusiness(
          name, description, tiktok, instagram, webpage, businessId);
      if (response != null) {
        business = response;
        _updated = true;
      }
      return true;
    } catch (e) {
      _updated = false;
      return false;
    }
  }

  bool getUpdated() => _updated;
}
