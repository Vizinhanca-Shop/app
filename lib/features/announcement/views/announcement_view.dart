import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/features/announcement/viewmodels/announcement_view_model.dart';
import 'package:vizinhanca_shop/features/announcement/views/widgets/images_carousel.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';
import 'package:vizinhanca_shop/shared/header.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

class AnnouncementViewArguments {
  final String announcementId;
  final String name;

  AnnouncementViewArguments({required this.announcementId, required this.name});
}

class AnnouncementView extends StatefulWidget {
  final AnnouncementViewArguments arguments;
  final AnnouncementViewModel viewModel;

  const AnnouncementView({
    super.key,
    required this.arguments,
    required this.viewModel,
  });

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  void _handleContactSeller({required String number}) async {
    final cleanNumber = number.replaceAll(RegExp(r'[^\d+]'), '');

    final formattedNumber =
        cleanNumber.startsWith('+')
            ? cleanNumber.substring(1)
            : (cleanNumber.startsWith('55') ? cleanNumber : '55$cleanNumber');

    final message =
        'Olá, vi seu anúncio no Vizinhança Shop e gostaria de mais informações.';

    final encodedMessage = Uri.encodeComponent(message);

    final whatsappUrl = 'https://wa.me/$formattedNumber?text=$encodedMessage';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        final webUrl =
            'https://api.whatsapp.com/send?phone=$formattedNumber&text=$encodedMessage';
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível abrir o WhatsApp. Verifique se o aplicativo está instalado.',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.handleGetAnnouncement(widget.arguments.announcementId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(title: widget.arguments.name),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          if (widget.viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImagesCarousel(images: widget.viewModel.announcement.images),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            intl.NumberFormat.currency(
                              locale: 'pt_BR',
                              symbol: 'R\$',
                            ).format(widget.viewModel.announcement.price),
                            style: GoogleFonts.sora(
                              fontSize: 24,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              widget.viewModel.announcement.category,
                              style: GoogleFonts.sora(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.viewModel.announcement.name,
                        style: GoogleFonts.sora(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.viewModel.announcement.description,
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[300]),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.redAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.viewModel.announcement.address ??
                                  'Endereço não informado',
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Vendedor',
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              widget.viewModel.announcement.seller.avatar,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.viewModel.announcement.seller.name,
                            style: GoogleFonts.sora(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            widget.viewModel.announcement.seller.phone,
                            style: GoogleFonts.sora(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          if (widget.viewModel.isLoading) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 24,
              top: 16,
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                _handleContactSeller(
                  number: widget.viewModel.announcement.seller.phone,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Image.asset(
                'assets/icons/whatsapp.png',
                width: 24,
                height: 24,
              ),
              label: Text(
                'Entrar em contato',
                style: GoogleFonts.sora(fontSize: 16, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
