import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/data/repositories/profile_repository.dart';

class MenuViewModel extends ChangeNotifier {
  final ProfileRepository _repository;
  UserModel user = UserModel.empty();
  bool _isLoading = false;

  MenuViewModel({required ProfileRepository repository})
    : _repository = repository;

  bool get isLoading => _isLoading;

  void fetchUserById({required String userId}) async {
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
}
