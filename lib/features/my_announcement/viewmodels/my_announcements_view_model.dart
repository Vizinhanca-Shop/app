import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/constants/categories.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/create_announcement_model.dart';
import 'package:vizinhanca_shop/data/repositories/announcement_repository.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class MyAnnouncementsViewModel extends ChangeNotifier {
  final AnnouncementRepository _repository;
  final List<AnnouncementModel> _announcements = [];
  List<AnnouncementModel> _filteredAnnouncements = [];
  bool _isLoading = false;
  bool _isEditing = false;

  MyAnnouncementsViewModel({required AnnouncementRepository repository})
    : _repository = repository;

  List<AnnouncementModel> get announcements => _announcements;
  List<AnnouncementModel> get filteredAnnouncements => _filteredAnnouncements;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  List<CategoryModel> get categories => defaultCategories;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final announcements = await _repository.fetchUserAnnouncements();
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

  Future<void> createAnnouncement(CreateAnnouncementModel announcement) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createAnnouncement(announcement);
      await fetchAnnouncements();
      ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 1),
          content: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Anúncio cadastrado com sucesso!',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Navigator.pop(AppRoutes.navigatorKey.currentContext!);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    _isEditing = true;
    notifyListeners();

    try {
      await _repository.updateAnnouncement(announcement);
      await fetchAnnouncements();
      ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 1),
          content: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Anúncio atualizado com sucesso!',
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Navigator.pop(AppRoutes.navigatorKey.currentContext!);
    } catch (e) {
      print(e);
    } finally {
      _isEditing = false;
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
