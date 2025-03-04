import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/constants/categories.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  AnnouncementModel _announcement = AnnouncementModel.empty();
  bool _isLoading = false;

  AnnouncementViewModel({required AnnouncementRepository repository})
    : _repository = repository;

  AnnouncementModel get announcement => _announcement;
  bool get isLoading => _isLoading;
  List<CategoryModel> get categories => defaultCategories;

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
