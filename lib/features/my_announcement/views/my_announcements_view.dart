import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/services/auth_service.dart';
import 'package:vizinhanca_shop/features/my_announcement/viewmodels/my_announcements_view_model.dart';
import 'package:vizinhanca_shop/features/my_announcement/views/my_announcement_details.dart';
import 'package:vizinhanca_shop/features/my_announcement/views/widgets/my_announcement_preview.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/shared/login.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class MyAnnouncementsView extends StatefulWidget {
  final MyAnnouncementsViewModel viewModel;
  final AuthService authService;

  const MyAnnouncementsView({
    super.key,
    required this.viewModel,
    required this.authService,
  });

  @override
  State<MyAnnouncementsView> createState() => _MyAnnouncementsViewState();
}

class _MyAnnouncementsViewState extends State<MyAnnouncementsView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;
  bool _isCheckingAuthStatus = true;

  void _checkAuthStatus() async {
    final isLoggedIn = await widget.authService.isUserLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isCheckingAuthStatus = false;
    });

    if (isLoggedIn) {
      widget.viewModel.fetchAnnouncements(userId: '2');
    }
  }

  void _navigateToNewAnnouncement() {
    Navigator.of(
      AppRoutes.navigatorKey.currentContext!,
    ).pushNamed(AppRoutes.newAnnouncement);
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();

    _searchController.addListener(() {
      if (_isLoggedIn) {
        widget.viewModel.handleFilterAnnouncements(_searchController.text);
      }
    });
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
        leadingWidth: MediaQuery.of(context).size.width,
        toolbarHeight: 80,
        scrolledUnderElevation: 0,
        actions: [
          Builder(
            builder: (context) {
              if (!_isLoggedIn) {
                return const SizedBox();
              }

              return IconButton(
                onPressed: _navigateToNewAnnouncement,
                icon: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.add_rounded, size: 32),
                ),
                color: Colors.white,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isLoggedIn)
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Buscar nos meus anúncios',
                  hintStyle: GoogleFonts.sora(color: Colors.grey[600]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, snapshot) {
                if (widget.viewModel.isLoading || _isCheckingAuthStatus) {
                  return Expanded(
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }

                if (!_isLoggedIn) {
                  return Expanded(
                    child: Transform.translate(
                      offset: Offset(0, -100),
                      child: Login(
                        title: 'Faça login para ver seus anúncios',
                        message:
                            'Você precisa estar logado para\nacessar seus anúncios',
                      ),
                    ),
                  );
                }

                if (widget.viewModel.announcements.isEmpty &&
                    _searchController.text.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Nenhum anúncio cadastrado',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                }

                if (widget.viewModel.filteredAnnouncements.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Nenhum anúncio encontrado',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              widget.viewModel.filteredAnnouncements.length,
                          itemBuilder: (context, index) {
                            final announcement =
                                widget.viewModel.filteredAnnouncements[index];
                            return MyAnnouncementPreview(
                              announcement: announcement,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.myAnnouncementDetails,
                                  arguments: MyAnnouncementDetailsArguments(
                                    announcementId: announcement.id,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
