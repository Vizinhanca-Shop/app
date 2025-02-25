import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/models/address_model.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';
import 'package:vizinhanca_shop/shared/header.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class AddressSearchView extends StatefulWidget {
  final AddressViewModel viewModel;

  const AddressSearchView({super.key, required this.viewModel});

  @override
  State<AddressSearchView> createState() => _AddressSearchViewState();
}

class _AddressSearchViewState extends State<AddressSearchView> {
  final TextEditingController _searchController = TextEditingController();

  String _formatAddressSubtitle(AddressModel address) {
    String? city = address.city;
    String? state = address.state;
    String? country = address.country;

    if (city != null && state != null) {
      return "$city, $state";
    } else if (state != null && country != null) {
      return "$state, $country";
    } else {
      return address.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: "Buscar endereço"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, snapshot) {
                return TextField(
                  controller: _searchController,
                  onChanged: widget.viewModel.onSearchChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                widget.viewModel.fetchSuggestions("");
                              },
                            )
                            : null,
                    hintText: 'Digite seu endereço...',
                    hintStyle: GoogleFonts.sora(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, snapshot) {
                if (widget.viewModel.isLoading) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  );
                }

                if (widget.viewModel.suggestions.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: widget.viewModel.suggestions.length,
                      itemBuilder: (context, index) {
                        final address = widget.viewModel.suggestions[index];
                        return ListTile(
                          title: Text(
                            address.name,
                            style: GoogleFonts.sora(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            _formatAddressSubtitle(address),
                            style: GoogleFonts.sora(color: Colors.grey[600]),
                          ),
                          onTap: () {
                            widget.viewModel.selectAddress(address);
                          },
                        );
                      },
                    ),
                  );
                }

                if (_searchController.text.isNotEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Nenhum endereço encontrado",
                        style: GoogleFonts.sora(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                if (_searchController.text.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Digite ao menos 3 caracteres para buscar",
                        style: GoogleFonts.sora(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
