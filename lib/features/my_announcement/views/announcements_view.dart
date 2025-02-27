import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/announcements_view_model.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class AnnouncementsView extends StatefulWidget {
  final AnnouncementsViewModel viewModel;

  const AnnouncementsView({super.key, required this.viewModel});

  @override
  State<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  void _navigateToNewAnnouncement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAnnouncementView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Meus Anúncios',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _navigateToNewAnnouncement,
            icon: const Icon(Icons.add_rounded, size: 32),
            color: AppColors.primary,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.viewModel.announcements.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(widget.viewModel.announcements[index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewAnnouncement,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewAnnouncementView extends StatelessWidget {
  const NewAnnouncementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Anúncio')),
      body: Center(child: const Text('Tela de cadastro de novo anúncio')),
    );
  }
}
