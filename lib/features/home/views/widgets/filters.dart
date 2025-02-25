import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  RangeValues _priceRange = const RangeValues(1, 100);
  double _distance = 5;
  String _selectedOrder = 'Mais recentes';

  void _handlePriceRangeChanged(RangeValues values) {
    setState(() {
      _priceRange = values;
    });
  }

  void _handleDistanceChanged(double value) {
    setState(() {
      _distance = value;
    });
  }

  void _handleOrderChanged(String value) {
    setState(() {
      _selectedOrder = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
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
                                _selectedOrder == 'Mais recentes'
                                    ? AppColors.primary
                                    : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Mais recentes',
                            style: GoogleFonts.sora(
                              color:
                                  _selectedOrder == 'Mais recentes'
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
                                _selectedOrder == 'Mais próximos'
                                    ? AppColors.primary
                                    : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Mais próximos',
                            style: GoogleFonts.sora(
                              color:
                                  _selectedOrder == 'Mais próximos'
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
                    'Faixa de preço:',
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
                        'R\$ 0,00',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'R\$ 100,00',
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
                    child: RangeSlider(
                      values: _priceRange,
                      min: 1,
                      max: 100,
                      onChanged: (values) {
                        _handlePriceRangeChanged(values);
                      },
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'De: ',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'R\$ ${_priceRange.start.toInt()},00',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Até: ',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'R\$ ${_priceRange.end.toInt()},00',
                        style: GoogleFonts.sora(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                      value: _distance,
                      min: 1,
                      max: 10,
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
                        '${_distance.toInt()} km',
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
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Aplicar filtros',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class FiltersBottomSheetHelper {
  static void showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const Filters(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
