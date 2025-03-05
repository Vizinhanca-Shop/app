import 'dart:async';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearchPinned = false;

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

  void _handleSearch(String search) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.homeViewModel.updateFilters(
        FiltersModel(
          radius: widget.homeViewModel.distance,
          order: widget.homeViewModel.selectedOrder,
          search: search,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Aqui, definimos um threshold para considerar que o header está fixado.
      bool pinned = _scrollController.offset > 80;
      if (pinned != _isSearchPinned) {
        setState(() {
          _isSearchPinned = pinned;
        });
      }

      // Controle de paginação
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (widget.homeViewModel.hasMore && !widget.homeViewModel.isLoading) {
          widget.homeViewModel.handleGetAnnouncements(loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sliver com o endereço e menu (rolam normalmente)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
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
                      return InkWell(
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
                                    constraints: const BoxConstraints(
                                      maxWidth: 240,
                                    ),
                                    child: Text(
                                      widget
                                              .addressViewModel
                                              .selectedAddress
                                              ?.name ??
                                          'Selecione um endereço',
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Sliver persistente com o campo de busca (pinned ou não, conforme _isSearchPinned)
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchFieldHeader(
              searchController: _searchController,
              onSearch: _handleSearch,
              onOpenFilters: _handleOpenFilters,
              isPinned: _isSearchPinned,
            ),
          ),
          // Sliver para a lista de categorias
          HomeCategoryList(
            homeViewModel: widget.homeViewModel,
            onCategoryChange: _handleCategoryChange,
          ),
          // Sliver para a grid de anúncios
          HomeAnnouncementGrid(homeViewModel: widget.homeViewModel),
        ],
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  final AddressViewModel addressViewModel;
  final VoidCallback onAddressSearch;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onOpenFilters;

  const HomeHeader({
    super.key,
    required this.addressViewModel,
    required this.onAddressSearch,
    required this.searchController,
    required this.onSearch,
    required this.onOpenFilters,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 160,
      pinned: true,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      flexibleSpace: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu_rounded, color: Colors.grey[800]),
                ),
                const SizedBox(width: 8),
                ListenableBuilder(
                  listenable: addressViewModel,
                  builder: (context, snapshot) {
                    if (addressViewModel.isLoading) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      );
                    }

                    return InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: onAddressSearch,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 240),
                                  child: Text(
                                    addressViewModel.selectedAddress?.name ??
                                        'Selecione um endereço',
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
                              '${addressViewModel.selectedAddress?.city} - ${addressViewModel.selectedAddress?.state}',
                              style: GoogleFonts.sora(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}

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
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < homeViewModel.announcements.length) {
                  final announcement = homeViewModel.announcements[index];
                  return AnnouncementPreview(announcement: announcement);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  );
                }
              },
              childCount:
                  homeViewModel.announcements.length +
                  (homeViewModel.hasMore ? 1 : 0),
            ),
          ),
        );
      },
    );
  }
}

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
    // Define a altura do container conforme o estado:
    // Quando fixo: header maior (ex.: 90) para incluir mais padding.
    // Quando não fixo: header menor (ex.: 70) para aproximar o campo da lista de categorias.
    final double containerHeight = isPinned ? 102 : 70;

    return Container(
      height: containerHeight,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Só adiciona espaçamento superior se estiver fixo.
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
