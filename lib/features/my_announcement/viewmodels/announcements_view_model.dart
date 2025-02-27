import 'package:flutter/material.dart';

class AnnouncementsViewModel extends ChangeNotifier {
  final List<String> _announcements = <String>[];

  List<String> get announcements => _announcements;

  void addAnnouncement(String announcement) {
    _announcements.add(announcement);
    notifyListeners();
  }
}
