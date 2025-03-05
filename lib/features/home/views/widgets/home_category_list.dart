import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/constants/categories.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class HomeCategoryList extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final Function(CategoryModel) onCategoryChange;

  const HomeCategoryList({
    super.key,
    required this.homeViewModel,
    required this.onCategoryChange,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SizedBox(
          height: 48,
          child: ListenableBuilder(
            listenable: homeViewModel,
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: defaultCategories.length,
                itemBuilder: (context, index) {
                  final category = defaultCategories[index];

                  return GestureDetector(
                    onTap: () => onCategoryChange(category),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color:
                            category.id == homeViewModel.selectedCategory?.id
                                ? AppColors.primary
                                : Colors.grey[100],
                      ),
                      child: Center(
                        child: Text(
                          category.name,
                          style: GoogleFonts.sora(
                            color:
                                category.id ==
                                        homeViewModel.selectedCategory?.id
                                    ? Colors.white
                                    : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
