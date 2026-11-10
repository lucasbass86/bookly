import 'package:bookly/models/models.dart';
import 'package:bookly/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CoverDetailPage extends StatelessWidget {
  static const String routeName = 'CoverDetailPage';
  const CoverDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Portada')),
      ),
      body: Hero(
        tag: book.id,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: AppColors.surface),
          imageProvider: Image.network(book.cover).image,
        ),
      ),
    );
  }
}
