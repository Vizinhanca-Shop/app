import 'package:flutter/material.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;

  HomeViewModel({required AnnouncementRepository repository})
    : _repository = repository;

  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;

  void handleGetAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      _announcements = await _repository.fetchAnnouncements();
    } catch (e) {
      _announcements = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
