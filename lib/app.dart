import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/di/locator.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/features/main/views/main_view.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: MaterialApp(
        navigatorKey: AppRoutes.navigatorKey,
        title: 'Vizinhança Shop',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: MainView(viewModel: locator<MainViewModel>()),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
