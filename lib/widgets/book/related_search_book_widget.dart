import 'dart:ui';

import 'package:bookly/models/models.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RelatedSearchBookWidget extends StatelessWidget {
  final Book book;
  final bool isSelected;
  final Function onTap;
  const RelatedSearchBookWidget({
    super.key,
    required this.book,
    required this.isSelected,
    required this.onTap,
  });

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
        child: Image.asset(Utils.logo, width: 150, height: 150),
      ),
      imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
    );

    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        padding: EdgeInsets.all(isSelected ? 10 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.border : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
        ),
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
      ),
    );
  }
}
