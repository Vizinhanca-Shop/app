import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/repositories/login_repository.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository;
  final AuthService _authService;
  bool _isLoading = false;

  LoginViewModel({
    required LoginRepository loginRepository,
    required AuthService authService,
  }) : _loginRepository = loginRepository,
       _authService = authService;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> loginWithGoogle(String accessToken) async {
    try {
      await _loginRepository.login(accessToken);
      _authService.setLoggedIn(true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
