import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
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
                Hero(
                  tag: announcement.id,
                  child: CachedNetworkImage(
                    imageUrl: announcement.images.first,
                    imageBuilder:
                        (context, imageProvider) => Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor: Colors.white.withValues(alpha: 0.5),
                          highlightColor: Colors.white.withValues(alpha: 0.2),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
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
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: announcement.seller.avatar,
                              placeholder:
                                  (context, url) => const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error),
                            ),
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
