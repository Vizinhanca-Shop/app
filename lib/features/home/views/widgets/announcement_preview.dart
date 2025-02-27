import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/features/announcement/views/announcement_view.dart';
import 'package:vizinhanca_shop/routes/app_routes.dart';

class AnnouncementPreview extends StatelessWidget {
  const AnnouncementPreview({super.key, required this.announcement});

  final AnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.announcement,
          arguments: AnnouncementViewArguments(
            announcementId: announcement.id,
            name: announcement.name,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      image: NetworkImage(announcement.images.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                            announcement.seller.avatar,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          announcement.seller.name,
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      announcement.name,
                      style: GoogleFonts.sora(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
