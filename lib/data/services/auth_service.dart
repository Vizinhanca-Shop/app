import 'package:vizinhanca_shop/data/services/local_storage_service.dart';

class AuthService {
  Future<bool> isUserLoggedIn() async {
    return false;
  }

  Future<void> logout() async {}
}

class AuthServiceImpl implements AuthService {
  final LocalStorageService _localStorageService;

  AuthServiceImpl({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService;

  @override
  Future<bool> isUserLoggedIn() async {
    return true;
    return await _localStorageService.getString('access_token') != null;
  }

  @override
  Future<void> logout() async {
    await _localStorageService.remove('access_token');
  }
}
