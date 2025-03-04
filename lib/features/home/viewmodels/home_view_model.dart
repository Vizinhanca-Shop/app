import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/filters_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  List<AnnouncementModel> _announcements = [];

  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  double _distance = 5;
  String _selectedOrder = 'Mais recentes';
  CategoryModel? _selectedCategory;

  HomeViewModel({required AnnouncementRepository repository})
    : _repository = repository;

  List<AnnouncementModel> get announcements => _announcements;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  double get distance => _distance;
  String get selectedOrder => _selectedOrder;
  CategoryModel? get selectedCategory => _selectedCategory;

  Future<void> handleGetAnnouncements({bool loadMore = false}) async {
    if (loadMore && !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      FiltersModel filters = FiltersModel(
        radius: _distance,
        order: _selectedOrder,
        category: _selectedCategory?.id ?? '',
      );
      final result = await _repository.fetchAnnouncements(
        page: _currentPage,
        limit: 10,
        filters: filters,
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
    _distance = filters.radius;
    _selectedOrder = filters.order;
    _selectedCategory =
        filters.category.isNotEmpty
            ? (filters.category == _selectedCategory?.id
                ? null
                : CategoryModel(id: filters.category, name: ''))
            : null;

    _currentPage = 1;
    _hasMore = true;

    notifyListeners();
    handleGetAnnouncements();
  }
}
