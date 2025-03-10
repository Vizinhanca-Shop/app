import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class ImagesCarousel extends StatefulWidget {
  final List<String> images;

  const ImagesCarousel({super.key, required this.images});

  @override
  State<ImagesCarousel> createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<ImagesCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onDotClicked(int index) {
    _controller.animateToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items:
              widget.images.map((image) {
                return CachedNetworkImage(
                  imageUrl: image,
                  imageBuilder:
                      (context, imageProvider) => Container(
                        height: 140,
                        decoration: BoxDecoration(
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
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) =>
                          const Icon(Icons.error, color: Colors.red),
                );
              }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: 280,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              _onPageChanged(index);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: widget.images.length,
              effect: const ScrollingDotsEffect(
                dotWidth: 6.0,
                dotHeight: 6.0,
                activeDotColor: AppColors.primary,
                dotColor: Colors.grey,
              ),
              onDotClicked: (index) {
                _onDotClicked(index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
