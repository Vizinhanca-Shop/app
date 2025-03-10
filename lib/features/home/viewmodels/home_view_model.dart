import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/filters_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';
import 'package:vizinhanca_shop/features/address/viewmodels/address_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  final AddressViewModel _addressViewModel;
  List<AnnouncementModel> _announcements = [];

  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  double _distance = 5;
  String _selectedOrder = 'Mais recentes';
  CategoryModel? _selectedCategory;
  String? _search;

  HomeViewModel({
    required AnnouncementRepository repository,
    required AddressViewModel addressViewModel,
  }) : _repository = repository,
       _addressViewModel = addressViewModel {
    _addressViewModel.addListener(() {
      handleGetAnnouncements();
    });
    _addressViewModel.setInitialAddress();
  }

  List<AnnouncementModel> get announcements => _announcements;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  double get distance => _distance;
  String get selectedOrder => _selectedOrder;
  CategoryModel? get selectedCategory => _selectedCategory;

  Future<void> handleGetAnnouncements({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _isLoading = true;

      notifyListeners();
    }

    if (loadMore && !_hasMore) return;

    notifyListeners();

    try {
      FiltersModel filters = FiltersModel(
        radius: _distance,
        order: _selectedOrder,
        category: _selectedCategory?.id ?? '',
        search: _search,
      );
      final result = await _repository.fetchAnnouncements(
        page: _currentPage,
        limit: 10,
        filters: filters,
        latitude: _addressViewModel.selectedAddress?.latitude,
        longitude: _addressViewModel.selectedAddress?.longitude,
      );
      final List<AnnouncementModel> newAnnouncements = result['announcements'];
      _totalPages = result['totalPages'];

      if (loadMore) {
        _announcements.addAll(newAnnouncements);
      } else {
        _announcements = newAnnouncements;
      }

      if (_currentPage < _totalPages) {
        _currentPage++;
        _hasMore = true;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _announcements = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilters(FiltersModel filters) {
    _isLoading = true;
    notifyListeners();

    _distance = filters.radius;
    _selectedOrder = filters.order;

    if (filters.category.isNotEmpty) {
      _selectedCategory =
          filters.category == _selectedCategory?.id
              ? null
              : CategoryModel(id: filters.category, name: '');
    }

    _search = filters.search;
    _currentPage = 1;
    _hasMore = true;

    notifyListeners();
    handleGetAnnouncements();
  }
}
