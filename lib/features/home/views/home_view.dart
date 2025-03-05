import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/filters_model.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/filters.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/home_announcement_grid.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/home_category_list.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/home_header.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/search_field_header.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';

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
      bool pinned = _scrollController.offset > 80;
      if (pinned != _isSearchPinned) {
        setState(() {
          _isSearchPinned = pinned;
        });
      }

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
          HomeHeader(
            addressViewModel: widget.addressViewModel,
            onAddressSearch: _handleAddressSearch,
            searchController: _searchController,
            onSearch: _handleSearch,
            onOpenFilters: _handleOpenFilters,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchFieldHeader(
              searchController: _searchController,
              onSearch: _handleSearch,
              onOpenFilters: _handleOpenFilters,
              isPinned: _isSearchPinned,
            ),
          ),
          HomeCategoryList(
            homeViewModel: widget.homeViewModel,
            onCategoryChange: _handleCategoryChange,
          ),
          HomeAnnouncementGrid(homeViewModel: widget.homeViewModel),
        ],
      ),
    );
  }
}
