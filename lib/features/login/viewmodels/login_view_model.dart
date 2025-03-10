import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/data/repositories/login_repository.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository;
  final AuthService _authService;
  final MainViewModel _mainViewModel;
  bool _isLoading = false;

  LoginViewModel({
    required LoginRepository loginRepository,
    required AuthService authService,
    required MainViewModel mainViewModel,
  }) : _loginRepository = loginRepository,
       _authService = authService,
       _mainViewModel = mainViewModel;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> loginWithGoogle(String accessToken) async {
    try {
      Map<String, dynamic> data = await _loginRepository.login(accessToken);

      if (data.isEmpty) {
        return false;
      }

      final user = UserModel.fromJson(data['user']);
      checkProfileCompletion(user);

      _authService.setLoggedIn(true);
      return true;
    } catch (e) {
      return false;
    }
  }

  void checkProfileCompletion(UserModel user) {
    if (user.name.isEmpty || user.phone.isEmpty || user.avatar.isEmpty) {
      _showCompleteProfileDialog();
    }
  }

  void _showCompleteProfileDialog() {
    showDialog(
      context: AppRoutes.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Complete seu Perfil",
                  style: GoogleFonts.sora(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  "Para que outros usuários possam entrar em contato com você, é necessário que seu perfil esteja completo.",
                  style: GoogleFonts.sora(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Agora não",
                        style: GoogleFonts.sora(color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _mainViewModel.navigateToProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Completar Perfil",
                        style: GoogleFonts.sora(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
