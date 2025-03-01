import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';

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

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  AnnouncementModel _announcement = AnnouncementModel.empty();
  bool _isLoading = false;

  AnnouncementViewModel({required AnnouncementRepository repository})
    : _repository = repository;

  AnnouncementModel get announcement => _announcement;
  bool get isLoading => _isLoading;
  List<CategoryModel> get categories => _categories;

  Future<void> handleGetAnnouncement(String announcementId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _announcement = await _repository.fetchAnnouncement(announcementId);
    } catch (e) {
      _announcement = AnnouncementModel.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
