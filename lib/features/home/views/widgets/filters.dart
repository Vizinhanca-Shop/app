import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/filters_model.dart';
import 'package:vizinhanca_shop/features/home/viewmodels/home_view_model.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FiltersBottomSheetHelper {
  static void showFiltersBottomSheet(
    BuildContext context, {
    required HomeViewModel homeViewModel,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Filters(homeViewModel: homeViewModel),
    );
  }
}

class Filters extends StatefulWidget {
  final HomeViewModel homeViewModel;

  const Filters({super.key, required this.homeViewModel});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late double _localDistance;
  late String _localOrder;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _localDistance = widget.homeViewModel.distance;
    _localOrder = widget.homeViewModel.selectedOrder;
  }

  void _handleDistanceChanged(double value) {
    setState(() {
      _localDistance = value;
    });
  }

  void _handleOrderChanged(String value) {
    setState(() {
      _localOrder = value;
    });
  }

  Future<void> _applyFilters() async {
    setState(() {
      _isLoading = true;
    });

    final FiltersModel filters = FiltersModel(
      order: _localOrder,
      radius: _localDistance,
    );

    try {
      widget.homeViewModel.updateFilters(filters);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Handle error if necessary
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filtros',
                            style: GoogleFonts.sora(
                              color: Colors.grey[800],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Text(
                        'Ordenar por:',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _handleOrderChanged('Mais recentes');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _localOrder == 'Mais recentes'
                                        ? AppColors.primary
                                        : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Mais recentes',
                                style: GoogleFonts.sora(
                                  color:
                                      _localOrder == 'Mais recentes'
                                          ? Colors.white
                                          : Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _handleOrderChanged('Mais próximos');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _localOrder == 'Mais próximos'
                                        ? AppColors.primary
                                        : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Mais próximos',
                                style: GoogleFonts.sora(
                                  color:
                                      _localOrder == 'Mais próximos'
                                          ? Colors.white
                                          : Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Distância:',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1km',
                            style: GoogleFonts.sora(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '10km',
                            style: GoogleFonts.sora(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderThemeData(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _localDistance,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: (value) {
                            _handleDistanceChanged(value);
                          },
                          activeColor: AppColors.primary,
                          inactiveColor: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Até: ',
                            style: GoogleFonts.sora(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${_localDistance.toInt()} km',
                            style: GoogleFonts.sora(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              'Aplicar filtros',
                              style: GoogleFonts.sora(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
