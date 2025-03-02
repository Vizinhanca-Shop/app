import 'package:flutter/foundation.dart';
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';

class AuthService extends ChangeNotifier {
  final LocalStorageService _localStorageService;

  AuthService({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> isUserLoggedIn() async {
    final token = await _localStorageService.getString('token');
    _isLoggedIn = token != null && token.isNotEmpty;
    return _isLoggedIn;
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await _localStorageService.remove('token');
    setLoggedIn(false);
  }
}
