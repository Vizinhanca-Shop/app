import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/address_model.dart';
import 'package:vizinhanca_shop/data/repositories/address_repository.dart';
import 'package:vizinhanca_shop/data/services/location_service.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressRepository _repository;
  final LocationService _locationService;
  List<AddressModel> _suggestions = [];
  Timer? _debounce;
  bool _isLoading = false;
  AddressModel? _selectedAddress;

  List<AddressModel> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  AddressModel? get selectedAddress => _selectedAddress;

  AddressViewModel({
    required AddressRepository repository,
    required LocationService locationService,
  }) : _repository = repository,
       _locationService = locationService;

  Future<void> setInitialAddress() async {
    _isLoading = true;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      final address = await _locationService.getAddressFromLocation(
        location.latitude,
        location.longitude,
      );
      _selectedAddress = address;
    } catch (e) {
      print("Erro ao buscar endereço inicial: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.length < 3) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.fetchSuggestions(query);
      _suggestions = response;
    } catch (e) {
      print("Erro ao buscar endereços: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      fetchSuggestions(query);
    });
  }

  void selectAddress(AddressModel address) async {
    _selectedAddress = await _locationService.getAddressFromLocation(
      double.parse(address.latitude),
      double.parse(address.longitude),
    );
    notifyListeners();

    Navigator.of(AppRoutes.navigatorKey.currentContext!).pop();
  }
}
