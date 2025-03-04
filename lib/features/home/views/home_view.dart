import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/constants/categories.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/filters_model.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/filters.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/announcement_preview.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class HomeView extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final AddressViewModel addressViewModel;

  const HomeView({
    super.key,
    required this.homeViewModel,
    required this.addressViewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  void _handleAddressSearch() {
    Navigator.of(context).pushNamed(AppRoutes.addressSearch);
  }

  void _handleOpenFilters() {
    FiltersBottomSheetHelper.showFiltersBottomSheet(
      context,
      homeViewModel: widget.homeViewModel,
    );
  }

  void _handleCategoryChange(CategoryModel category) {
    widget.homeViewModel.updateFilters(
      FiltersModel(
        radius: widget.homeViewModel.distance,
        order: widget.homeViewModel.selectedOrder,
        category: category.id,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.addressViewModel.setInitialAddress();
    widget.homeViewModel.handleGetAnnouncements();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.homeViewModel.hasMore && !widget.homeViewModel.isLoading) {
        widget.homeViewModel.handleGetAnnouncements(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: MediaQuery.of(context).size.width,
        scrolledUnderElevation: 0,
        toolbarHeight: 160,
        leading: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu_rounded, color: Colors.grey[800]),
                  ),
                  const SizedBox(width: 8),
                  ListenableBuilder(
                    listenable: widget.addressViewModel,
                    builder: (context, snapshot) {
                      if (widget.addressViewModel.isLoading) {
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        );
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: _handleAddressSearch,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 240,
                                        ),
                                        child: Text(
                                          widget
                                                      .addressViewModel
                                                      .selectedAddress
                                                      ?.name !=
                                                  null
                                              ? '${widget.addressViewModel.selectedAddress?.name}'
                                              : 'Selecione um endereço',
                                          style: GoogleFonts.sora(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[800],
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${widget.addressViewModel.selectedAddress?.city} - ${widget.addressViewModel.selectedAddress?.state}',
                                    style: GoogleFonts.sora(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
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
                        onPressed: _handleOpenFilters,
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
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListenableBuilder(
                listenable: widget.homeViewModel,
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: defaultCategories.length,
                    itemBuilder: (context, index) {
                      final category = defaultCategories[index];

                      return GestureDetector(
                        onTap: () => _handleCategoryChange(category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                category.id ==
                                        widget
                                            .homeViewModel
                                            .selectedCategory
                                            ?.id
                                    ? AppColors.primary
                                    : Colors.grey[100],
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              style: GoogleFonts.sora(
                                color:
                                    category.id ==
                                            widget
                                                .homeViewModel
                                                .selectedCategory
                                                ?.id
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
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: widget.homeViewModel,
              builder: (context, snapshot) {
                if (widget.homeViewModel.isLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  );
                }

                if (widget.homeViewModel.announcements.isEmpty &&
                    !widget.homeViewModel.isLoading) {
                  return Expanded(
                    child: Center(
                      child: Transform.translate(
                        offset: const Offset(0, -100),
                        child: Text(
                          'Nenhum anúncio encontrado',
                          style: GoogleFonts.sora(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount:
                        widget.homeViewModel.announcements.length +
                        (widget.homeViewModel.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < widget.homeViewModel.announcements.length) {
                        final announcement =
                            widget.homeViewModel.announcements[index];
                        return AnnouncementPreview(announcement: announcement);
                      } else {
                        return Center(
                          child: Transform.translate(
                            offset: Offset(
                              MediaQuery.of(context).size.width / 4,
                              -100,
                            ),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
