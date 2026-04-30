import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageSlider extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final Function(int) onPageChanged;

  const CustomImageSlider({
    super.key,
    required this.images,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: images.length,
      itemBuilder: (context, index) {
         Stack(
          children: [
            CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              memCacheWidth: 800,

              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),

              errorWidget: (context, url, error) =>
              const Icon(Icons.error),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}