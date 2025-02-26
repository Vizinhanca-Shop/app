import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/filters.dart';
import 'package:vizinhanca_shop/features/home/views/widgets/product_preview.dart';
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
  void _handleAddressSearch() {
    Navigator.of(context).pushNamed(AppRoutes.addressSearch);
  }

  void _handleOpenFilters() {
    FiltersBottomSheetHelper.showFiltersBottomSheet(context);
  }

  @override
  void initState() {
    super.initState();
    widget.addressViewModel.setInitialAddress();
    widget.homeViewModel.handleGetProducts();
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
                                      SizedBox(
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
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: index == 0 ? AppColors.primary : Colors.grey[100],
                    ),
                    child: Center(
                      child: Text(
                        'Categoria $index',
                        style: GoogleFonts.sora(
                          color: index == 0 ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: widget.homeViewModel,
              builder: (context, snapshot) {
                if (widget.homeViewModel.isLoading) {
                  return Expanded(
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: widget.homeViewModel.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.homeViewModel.products[index];
                      return ProductPreview(product: product);
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
