import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/announcement_preview.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class HomeAnnouncementGrid extends StatelessWidget {
  final HomeViewModel homeViewModel;

  const HomeAnnouncementGrid({super.key, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: homeViewModel,
      builder: (context, snapshot) {
        if (homeViewModel.isLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          );
        }

        if (homeViewModel.announcements.isEmpty && !homeViewModel.isLoading) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                'Nenhum anúncio encontrado',
                style: GoogleFonts.sora(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final announcement = homeViewModel.announcements[index];
              return AnnouncementPreview(announcement: announcement);
            }, childCount: homeViewModel.announcements.length),
          ),
        );
      },
    );
  }
}
