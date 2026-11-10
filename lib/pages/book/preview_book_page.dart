import 'package:bookly/models/models.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/utils.dart';
import 'package:flutter/material.dart';

class PreviewBookPage extends StatelessWidget {
  static const String routeName = 'PreviewBookPage';
  const PreviewBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    OpenLibrary? openLibrary;
    Google? google;
    HardcoverBook? hardcoverBook;
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    openLibrary = arguments[0];
    google = arguments[1];
    hardcoverBook = arguments[2];
    final TextStyle expandedStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
      fontSize: 23,
    );
    final TextStyle titleStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w500,
      fontSize: 19,
    );
    final TextStyle authorStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w300,
      fontSize: 19,
    );
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text('Elige una opción'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 20,
            children: [
              if (openLibrary != null)
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 3),
                    ),
                    child: ExpansionTile(
                      childrenPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      title: Text('OpenLibrary', style: expandedStyle),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 20,
                          children: [
                            Row(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (openLibrary.cover != '')
                                  ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(20),
                                    child: Image.network(
                                      openLibrary.cover,
                                      width: 100,
                                      height: 150,
                                    ),
                                  ),
                                if (openLibrary.cover == '')
                                  Image.asset(Utils.logo, width: 100, height: 150),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(openLibrary.title ?? '', style: titleStyle),
                                      if (openLibrary.authors.isNotEmpty)
                                        Text(openLibrary.authors[0].name ?? '', style: authorStyle),
                                      if (openLibrary.publishers.isNotEmpty)
                                        Text(openLibrary.publishers[0].name!),
                                      if (openLibrary.publishDate != null)
                                        Text(openLibrary.publishDate!),
                                      if (openLibrary.numberOfPages != null &&
                                          openLibrary.numberOfPages != 0)
                                        Text('Pags:${openLibrary.numberOfPages.toString()}'),
                                      if (openLibrary.subtitle != null) Text(openLibrary.subtitle!),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, openLibrary),
                              child: Text('Seleccionar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (google != null)
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 3),
                    ),
                    child: ExpansionTile(
                      childrenPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      title: Text('Google', style: expandedStyle),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 20,
                          children: [
                            Row(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (google.thumbnail != null)
                                  ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(20),
                                    child: Image.network(
                                      google.thumbnail!,
                                      width: 100,
                                      height: 150,
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(google.title, style: titleStyle),
                                      if (google.authors.isNotEmpty)
                                        Text(google.authors[0], style: authorStyle),
                                      if (google.publisher != null) Text(google.publisher!),
                                      if (google.publishedDate != null) Text(google.publishedDate!),
                                      if (google.pageCount != null && google.pageCount != 0)
                                        Text('Pags:${google.pageCount}'),
                                      if (google.description != null)
                                        Text(google.description!, textAlign: TextAlign.justify),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, google),
                              child: Text('Seleccionar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (hardcoverBook != null)
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 3),
                    ),
                    child: ExpansionTile(
                      childrenPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      title: Text('HardCover', style: expandedStyle),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 20,
                          children: [
                            Row(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (hardcoverBook.imageUrl != null)
                                  ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(20),
                                    child: Image.network(
                                      hardcoverBook.imageUrl!,
                                      width: 100,
                                      height: 150,
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(hardcoverBook.title, style: titleStyle),
                                      if (hardcoverBook.author != null)
                                        Text(hardcoverBook.author!, style: authorStyle),
                                      if (hardcoverBook.releaseDate != null)
                                        Text(
                                          Utils.dateEnglishToSpanish(hardcoverBook.releaseDate!),
                                        ),
                                      if (hardcoverBook.pages != null && hardcoverBook.pages != 0)
                                        Text('Pags:${hardcoverBook.pages}'),
                                      if (hardcoverBook.description != null)
                                        Text(
                                          hardcoverBook.description!,
                                          textAlign: TextAlign.justify,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, hardcoverBook),
                              child: Text('Seleccionar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
