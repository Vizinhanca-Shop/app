import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/di/locator.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/menu/views/menu_view.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/views/my_announcements_view.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/home_view.dart';
import 'package:vizinhanca_shop/features/profile/viewmodels/profile_view_model.dart';

class MainViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  static final List<Widget> _screens = <Widget>[
    HomeView(
      addressViewModel: locator<AddressViewModel>(),
      homeViewModel: locator<HomeViewModel>(),
    ),
    MyAnnouncementsView(
      viewModel: locator<MyAnnouncementsViewModel>(),
      authService: locator<AuthService>(),
    ),
    MenuView(
      authService: locator<AuthService>(),
      viewModel: locator<MainViewModel>(),
      profileViewModel: locator<ProfileViewModel>(),
    ),
  ];

  int get currentIndex => _currentIndex;
  List<Widget> get screens => _screens;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void navigateToHome() {
    _currentIndex = 0;
    notifyListeners();
  }
}
