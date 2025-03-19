import 'package:flutter/material.dart';
import 'package:unipadonde/modeldata/user_model.dart';
import 'package:unipadonde/profilepage/profile_repo.dart';

class ProfileViewModel extends ChangeNotifier {
  User? user;
  bool _loading = true;
  final ProfileRepo _repo = ProfileRepo();
  final int userId;

  ProfileViewModel({required this.userId}) {
    getUserData(userId);
  }
  // Método para obtener los datos del usuario desde la tabla "usuario"
  Future<void> getUserData(int userId) async {
    _loading = true;
    final response = await _repo.getUserData(userId);
    if (response != null) {
      user = response;
    }
    _loading = false;
    notifyListeners();
  }

  // Método para actualizar los datos del usuario en la tabla "usuario"
  Future<bool> updateUserData(int userId, Map<String, dynamic> data) async {
    final response = await _repo.updateUserData(userId, data);
    if (response != null) {
      user = response;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
