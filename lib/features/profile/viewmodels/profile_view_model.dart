import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/data/repositories/profile_repository.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;
  UserModel user = UserModel.empty();
  bool _isLoading = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  ProfileViewModel({required ProfileRepository repository})
    : _repository = repository;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
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

  void updateUser({
    required String name,
    required String phone,
    String? avatar,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      await _repository.updateUser(name: name, phone: phone, avatar: avatar);
      ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Perfil atualizado com sucesso!',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser() async {
    _isDeleting = true;
    notifyListeners();

    try {
      await _repository.deleteUser();

      ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Conta excluída com sucesso!',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      Navigator.of(AppRoutes.navigatorKey.currentContext!).pop();
    } catch (e) {
      print(e);
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
