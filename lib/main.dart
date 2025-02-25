import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vizinhanca_shop/app.dart';
import 'package:vizinhanca_shop/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  runApp(const App());
}
