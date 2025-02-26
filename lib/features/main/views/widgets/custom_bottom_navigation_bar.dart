import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/features/main/viewmodels/main_view_model.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final MainViewModel mainViewModel;

  const CustomBottomNavigationBar({super.key, required this.mainViewModel});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        body: ListenableBuilder(
          listenable: widget.mainViewModel,
          builder: (context, snapshot) {
            return Center(
              child: widget.mainViewModel.screens.elementAt(
                widget.mainViewModel.currentIndex,
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ListenableBuilder(
          listenable: widget.mainViewModel,
          builder: (context, snapshot) {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              onTap: widget.mainViewModel.setIndex,
              currentIndex: widget.mainViewModel.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Perfil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_rounded),
                  label: 'Meus anúncios',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
