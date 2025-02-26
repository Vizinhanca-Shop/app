import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/di/locator.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/views/my_announcements_view.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/home_view.dart';

class MainViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  static final List<Widget> _screens = <Widget>[
    HomeView(
      addressViewModel: locator<AddressViewModel>(),
      homeViewModel: locator<HomeViewModel>(),
    ),
    MyAnnouncementsView(viewModel: locator<MyAnnouncementsViewModel>()),
    Scaffold(body: Center(child: Text('Profile'))),
  ];

  int get currentIndex => _currentIndex;
  List<Widget> get screens => _screens;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
