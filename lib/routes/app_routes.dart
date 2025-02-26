import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/di/locator.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/address/views/address_search_view.dart';
import 'package:vizinhanca_shop/features/home/views/home_view.dart';
import 'package:vizinhanca_shop/features/product/viewmodels/product_view_model.dart';
import 'package:vizinhanca_shop/features/product/views/product_view.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addressSearch = '/address-search';
  static const String product = '/product';

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
          case login:
            return Scaffold(body: Center(child: Text('Login')));
          case register:
            return Scaffold(body: Center(child: Text('Register')));
          case home:
            return HomeView(addressViewModel: locator<AddressViewModel>());
          case addressSearch:
            return AddressSearchView(viewModel: locator<AddressViewModel>());
          case product:
            return ProductView(
              arguments: settings.arguments as ProductViewArguments,
              viewModel: locator<ProductViewModel>(),
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
