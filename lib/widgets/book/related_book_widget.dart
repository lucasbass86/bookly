import 'dart:ui';

import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RelatedBookWidget extends StatelessWidget {
  final Book book;
  final Function onLongPress;
  const RelatedBookWidget({super.key, required this.book, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: book.cover,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.border,
        child: Image.asset(Utils.logo, width: 120, height: 150),
      ),
      imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, BookDetailPage.routeName, arguments: book),
      onLongPress: () => onLongPress.call(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: book.id,
          flightShuttleBuilder: (context, animation, direction, fromContext, toContext) {
            return AnimatedBuilder(
              animation: animation,
              child: image,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(lerpDouble(8, 24, animation.value)!),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: lerpDouble(4, 20, animation.value)!,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(lerpDouble(8, 24, animation.value)!),
                    child: child,
                  ),
                );
              },
            );
          },
          child: image,
        ),
      ),
    );
  }
}
