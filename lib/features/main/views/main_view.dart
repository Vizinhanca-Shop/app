import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/features/main/views/widgets/custom_bottom_navigation_bar.dart';

class MainView extends StatelessWidget {
  final MainViewModel viewModel;

  const MainView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(mainViewModel: viewModel);
  }
}
