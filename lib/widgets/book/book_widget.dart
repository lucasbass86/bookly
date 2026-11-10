import 'dart:ui';

import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookWidget extends StatelessWidget {
  final Book book;
  final Function? onTap;
  final Function? onLongPress;
  final bool? isSelected;
  const BookWidget({super.key, required this.book, this.onTap, this.isSelected, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: book.cover,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
      ),
      errorWidget: (context, url, error) => Image.asset(Utils.logo, width: 150, height: 200),
      imageBuilder: (context, imageProvider) =>
          Image(image: imageProvider, width: 150, height: 200, fit: BoxFit.fitWidth),
    );

    return GestureDetector(
      onLongPress: () => onLongPress?.call(),
      onTap: () {
        if (onTap != null) {
          onTap!.call();
        } else {
          Navigator.pushNamed(context, BookDetailPage.routeName, arguments: book);
        }
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: 190),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
            width: isSelected != null && isSelected! ? 5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Hero(
                    tag: book.id,
                    flightShuttleBuilder: (context, animation, direction, fromContext, toContext) {
                      return AnimatedBuilder(
                        animation: animation,
                        child: image,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                lerpDouble(8, 24, animation.value)!,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: lerpDouble(4, 20, animation.value)!,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                lerpDouble(8, 24, animation.value)!,
                              ),
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
            ),
            5.h,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title ?? '',
                  style: TextStyle(fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
                5.h,
                Text(book.author ?? '', overflow: TextOverflow.ellipsis),
                5.h,
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: book.state.color, shape: BoxShape.circle),
                    ),
                    Text(book.state.displayName, style: TextStyle(color: book.state.color)),
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
