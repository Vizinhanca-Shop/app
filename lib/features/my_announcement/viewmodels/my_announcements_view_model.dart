import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';

class MyAnnouncementsViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  final List<AnnouncementModel> _announcements = [];
  List<AnnouncementModel> _filteredAnnouncements = [];
  bool _isLoading = false;

  final List<CategoryModel> _categories = [
    CategoryModel(id: '1', name: 'Alimentos e Bebidas'),
    CategoryModel(id: '2', name: 'Eletrônicos e Acessórios'),
    CategoryModel(id: '3', name: 'Moda e Acessórios'),
    CategoryModel(id: '4', name: 'Casa e Decoração'),
    CategoryModel(id: '5', name: 'Serviços'),
    CategoryModel(id: '6', name: 'Artesanato e Personalizados'),
    CategoryModel(id: '7', name: 'Infantil'),
    CategoryModel(id: '8', name: 'Automotivo'),
    CategoryModel(id: '9', name: 'Esportes e Lazer'),
    CategoryModel(id: '10', name: 'Beleza e Estética'),
    CategoryModel(id: '11', name: 'Outros'),
  ];

  MyAnnouncementsViewModel({required AnnouncementRepository repository})
    : _repository = repository;

  List<AnnouncementModel> get announcements => _announcements;
  List<AnnouncementModel> get filteredAnnouncements => _filteredAnnouncements;
  bool get isLoading => _isLoading;
  List<CategoryModel> get categories => _categories;

  Future<void> fetchAnnouncements({required String userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final announcements = await _repository.fetchUserAnnouncements(userId);
      _announcements.clear();
      _announcements.addAll(announcements);
      _filteredAnnouncements.clear();
      _filteredAnnouncements.addAll(announcements);
      notifyListeners();
    } catch (e) {
      _announcements.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addAnnouncement(AnnouncementModel announcement) {
    _announcements.add(announcement);
    notifyListeners();
  }

  Future<void> removeAnnouncement(String announcementId) async {
    final index = _announcements.indexWhere(
      (element) => element.id == announcementId,
    );
    if (index != -1) {
      _announcements.removeAt(index);
      notifyListeners();
    }
  }

  void updateAnnouncement(AnnouncementModel announcement) {
    final index = _announcements.indexWhere(
      (element) => element.id == announcement.id,
    );
    if (index != -1) {
      _announcements[index] = announcement;
      notifyListeners();
    }
  }

  void handleFilterAnnouncements(String query) {
    if (query.isEmpty) {
      _filteredAnnouncements = List.from(_announcements);
    } else {
      _filteredAnnouncements =
          _announcements
              .where(
                (element) =>
                    element.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }
}
