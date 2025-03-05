import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class SearchFieldHeader extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onOpenFilters;
  final bool isPinned;

  SearchFieldHeader({
    required this.searchController,
    required this.onSearch,
    required this.onOpenFilters,
    required this.isPinned,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double containerHeight = isPinned ? 102 : 70;

    return Container(
      height: containerHeight,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPinned) const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    IconButton(
                      onPressed: onOpenFilters,
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                hintText: 'Pesquise por produtos, locais e categorias',
                hintStyle: GoogleFonts.sora(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 16.0,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          SizedBox(height: isPinned ? 20 : 4),
        ],
      ),
    );
  }

  @override
  double get maxExtent => isPinned ? 102 : 70;

  @override
  double get minExtent => isPinned ? 102 : 70;

  @override
  bool shouldRebuild(covariant SearchFieldHeader oldDelegate) {
    return oldDelegate.isPinned != isPinned ||
        oldDelegate.searchController != searchController;
  }
}
