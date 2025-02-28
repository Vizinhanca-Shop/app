import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/di/locator.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/address/views/address_search_view.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/home_view.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/features/main/views/main_view.dart';
import 'package:vizinhanca_shop/features/announcement/viewmodels/announcement_view_model.dart';
import 'package:vizinhanca_shop/features/announcement/views/announcement_view.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/views/new_announcement_view.dart';
import 'package:vizinhanca_shop/features/profile/viewmodels/profile_view_model.dart';
import 'package:vizinhanca_shop/features/profile/views/profile_view.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String main = '/main';
  static const String home = '/home';
  static const String addressSearch = '/address-search';
  static const String announcement = '/announcement';
  static const String newAnnouncement = '/new-announcement';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0, 0.0),
        ).animate(secondaryAnimation);

        return SlideTransition(
          position: slideIn,
          child: SlideTransition(position: slideOut, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case main:
            return MainView(viewModel: locator<MainViewModel>());
          case home:
            return HomeView(
              homeViewModel: locator<HomeViewModel>(),
              addressViewModel: locator<AddressViewModel>(),
            );
          case addressSearch:
            return AddressSearchView(viewModel: locator<AddressViewModel>());
          case announcement:
            return AnnouncementView(
              arguments: settings.arguments as AnnouncementViewArguments,
              viewModel: locator<AnnouncementViewModel>(),
            );
          case newAnnouncement:
            return NewAnnouncementView(
              viewModel: locator<MyAnnouncementsViewModel>(),
            );
          case profile:
            return ProfileView(
              authService: locator<AuthService>(),
              viewModel: locator<ProfileViewModel>(),
            );
          default:
            return Scaffold(
              body: Center(
                child: Text('Rota não encontrada: ${settings.name}'),
              ),
            );
        }
      },
    );
  }
}
