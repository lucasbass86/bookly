import 'dart:ui';

import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookSearchWidget extends StatelessWidget {
  final Book book;
  const BookSearchWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: book.cover,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
      ),
      errorWidget: (context, url, error) => Image.asset(Utils.logo, width: 75, height: 100),
      imageBuilder: (context, imageProvider) =>
          Image(image: imageProvider, width: 75, fit: BoxFit.fitWidth),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, BookDetailPage.routeName, arguments: book),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Hero(
                        tag: book.id,
                        flightShuttleBuilder:
                            (context, animation, direction, fromContext, toContext) {
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
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title ?? '',
                          style: TextStyle(fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(book.author ?? ''),
                        Row(
                          spacing: 10,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: book.state.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(book.state.displayName, style: TextStyle(color: book.state.color)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }
}
