import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

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
    return SliverToBoxAdapter(
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
                              constraints: const BoxConstraints(maxWidth: 240),
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
    );
  }
}
