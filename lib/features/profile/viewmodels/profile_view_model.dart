import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/data/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;
  UserModel user = UserModel.empty();
  bool _isLoading = false;
  bool _isDeleting = false;

  ProfileViewModel({required ProfileRepository repository})
    : _repository = repository;

  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;

  Future<void> fetchUserById({required String userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      user = await _repository.fetchUserById(userId: userId);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateUser({required UserModel user}) {
    this.user = user;
    notifyListeners();
  }

  Future<void> deleteUser({required String userId}) async {
    _isDeleting = true;
    notifyListeners();

    try {
      await _repository.deleteUser(userId: userId);
    } catch (e) {
      print(e);
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
