import 'dart:io';

import 'package:bookly/dialogs/dialogs.dart';
import 'package:bookly/models/models.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Helper {
  static Future<File?> takeCoverPhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1200,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return File(photo.path);

      // await recognizeText(photo.path);
    } catch (e) {
      if (!context.mounted) return null;
      Utils.snackBar(context, 'No se pudo capturar la portada.', isBad: true);
    }
    return null;
  }

  static Future<File?> pickCoverFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 85,
      );
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      if (!context.mounted) return null;
      Utils.showSnackBar(context, 'No se pudo seleccionar la imagen', isBad: true);
    }
    return null;
  }

  static Future<String?> recognizeText(BuildContext context, String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      if (!context.mounted) return null;
      return recognizedText.text;
    } catch (e) {
      debugPrint('Error al reconocer el texto: $e');
    } finally {
      await textRecognizer.close();
    }
    return null;
  }

  static Future<OpenLibrary?> scanOpenLibrary(BuildContext context, String isbn) async {
    OpenLibrary? openLibrary;
    openLibrary = await BookSearchService.searchByIsbn(isbn.toString());
    if (openLibrary == null && context.mounted) {
      return null;
    }
    // if (context.mounted) {
    //   Utils.snackBar(context, 'Encontrado en OpenLibrary 🥳');
    // }
    return openLibrary;
  }

  static Future<Google?> scanGoogle(BuildContext context, String isbn) async {
    Google? google;
    google = await GoogleBooksService.getBookByIsbn(isbn);
    if (google == null && context.mounted) {
      return null;
    }
    // if (context.mounted) {
    //   Utils.snackBar(context, 'Encontrado en Google 🥳');
    // }
    return google;
  }

  static Future<HardcoverBook?> scanHardcover(BuildContext context, String isbn) async {
    List<HardcoverBook>? list = await HardcoverService.searchBooks(isbn);
    if ((list == null || list.isEmpty) && context.mounted) {
      return null;
    }
    // if (context.mounted) {
    //   Utils.snackBar(context, 'Encontrado en HardCover 🥳');
    // }
    return list![0];
  }

  static Future<bool> checkBookExists(BuildContext context, String isbn) async {
    BookService bookService = Provider.of<BookService>(context, listen: false);
    Book? book;
    if (bookService.books.any((b) => b.isbn == isbn)) {
      book = bookService.books.firstWhere((b) => b.isbn == isbn);
      await showMessage(
        context: context,
        title: 'Este libro ya está en tu biblioteca',
        header: book.cover.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Image.network(book.cover, width: 150, height: 200),
                ),
              )
            : SizedBox.shrink(),
        showCancel: false,
      );
      return true;
    }
    return false;
  }
}
