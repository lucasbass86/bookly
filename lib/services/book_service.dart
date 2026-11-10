import 'dart:convert';
import 'dart:io';

import 'package:bookly/models/models.dart';
import 'package:bookly/preferences/preferences.dart';
import 'package:bookly/secrets/secrets.dart';
import 'package:bookly/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookService with ChangeNotifier {
  List<Book> books = [];

  BookService() {
    getBooks();
  }

  Future<bool> insertBook(Book book) async {
    final response = await http.post(
      Uri.parse(Secret.urlInsert),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'userId': book.userId,
        'id': book.id,
        'title': book.title ?? '',
        'author': book.author ?? '',
        'category': book.category.name,
        'publisher': book.publisher ?? '',
        'publishYear': book.publishYear ?? '',
        'pages': book.pages?.toString() ?? '',
        'isbn': book.isbn ?? '',
        'observations': book.observations ?? '',
        'state': book.state.name,
        'coverUrl': book.coverUrl ?? '',
      },
    );

    if (response.statusCode != 200) {
      return false;
    }

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      return false;
    }
    getBooks();
    return true;
  }

  Future<List<Book>> getBooks() async {
    final response = await http.post(
      Uri.parse(Secret.urlGetBooks),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'userId': Preferences.userId},
    );

    if (response.statusCode != 200 || response.body.isEmpty) {
      return [];
    }

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      return [];
    }

    final List<dynamic> booksJson = data['books'];

    books = booksJson.map((json) {
      return Book.fromMap(json);
    }).toList();
    notifyListeners();
    sortBooks();
    return books;
  }

  void sortBooks() {
    switch (Preferences.bookOrder) {
      case BookOrder.title:
        if (Preferences.bookSort == BookSort.asc) {
          books.sort((a, b) => a.title!.compareTo(b.title!));
        } else {
          books.sort((a, b) => b.title!.compareTo(a.title!));
        }
        break;
      case BookOrder.author:
        if (Preferences.bookSort == BookSort.asc) {
          books.sort((a, b) => a.author!.compareTo(b.author!));
        } else {
          books.sort((a, b) => b.author!.compareTo(a.author!));
        }
        break;
      case BookOrder.category:
        if (Preferences.bookSort == BookSort.asc) {
          books.sort((a, b) => a.category.displayName.compareTo(b.category.displayName));
        } else {
          books.sort((a, b) => b.category.displayName.compareTo(a.category.displayName));
        }
        break;
      case BookOrder.publisher:
        if (Preferences.bookSort == BookSort.asc) {
          books.sort((a, b) => a.publisher!.compareTo(b.publisher!));
        } else {
          books.sort((a, b) => b.publisher!.compareTo(a.publisher!));
        }
        break;
      case BookOrder.publisherYear:
        if (Preferences.bookSort == BookSort.asc) {
          books.sort((a, b) => a.publishYear!.compareTo(b.publishYear!));
        } else {
          books.sort((a, b) => b.publishYear!.compareTo(a.publishYear!));
        }
        break;
      case BookOrder.pages:
        if (Preferences.bookSort == BookSort.asc) {
          books.sort((a, b) => a.pages!.compareTo(b.pages!));
        } else {
          books.sort((a, b) => b.pages!.compareTo(a.pages!));
        }
        break;
    }

    notifyListeners();
  }

  Future<String?> uploadCover({required String bookId, required File image}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(Secret.urlUploadCover));
      request.fields['userId'] = Preferences.userId;
      request.fields['id'] = bookId;
      request.files.add(await http.MultipartFile.fromPath('cover', image.path));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 || response.body.isEmpty) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data['success'] != true) {
        return null;
      }

      return data['coverUrl'];
    } catch (e) {
      debugPrint('Error subiendo portada: $e');
      return null;
    }
  }

  Future<String?> uploadCoverFromUrl({required String bookId, required String imageUrl}) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return null;
      }

      final directory = await Directory.systemTemp.createTemp();
      final file = File('${directory.path}/cover.jpg');
      await file.writeAsBytes(response.bodyBytes);
      return await uploadCover(bookId: bookId, image: file);
    } catch (e) {
      debugPrint('Error descargando portada: $e');
      return null;
    }
  }

  Future<bool> updateBookState(Book book) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlUpdateState),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'userId': book.userId, 'id': book.id, 'state': book.state.name},
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        return false;
      }

      final data = jsonDecode(response.body);
      getBooks();
      return data['success'] == true;
    } catch (e) {
      debugPrint('Error actualizando estado: $e');
      return false;
    }
  }

  Future<bool> deleteBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlDelete),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'userId': book.userId, 'id': book.id},
      );
      if (response.statusCode != 200 || response.body.isEmpty) {
        return false;
      }
      final data = jsonDecode(response.body);
      getBooks();
      return data['success'] == true;
    } catch (e) {
      debugPrint('Error eliminando libro: $e');
      return false;
    }
  }

  Future<bool> updateBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlUpdate),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'userId': book.userId,
          'id': book.id,
          'title': book.title ?? '',
          'author': book.author ?? '',
          'category': book.category.name,
          'publisher': book.publisher ?? '',
          'publishYear': book.publishYear ?? '',
          'pages': book.pages?.toString() ?? '',
          'isbn': book.isbn ?? '',
          'observations': book.observations ?? '',
          'state': book.state.name,
          'coverUrl': book.coverUrl ?? '',
        },
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        return false;
      }

      final data = jsonDecode(response.body);
      getBooks();
      return data['success'] == true;
    } catch (e) {
      debugPrint('Error actualizando libro: $e');
      return false;
    }
  }

  Future<bool> insertRelatedBook({
    required String userId,
    required String id,
    required String idrelated,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlRelatedInsert),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'userId': userId, 'id': id, 'idrelated': idrelated},
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        return false;
      }

      final data = jsonDecode(response.body);

      return data['success'] == true;
    } catch (e) {
      debugPrint('Error insertando libro relacionado: $e');
      return false;
    }
  }

  Future<bool> deleteRelatedBook({required String id, required String idrelated}) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlRelatedDelete),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'userId': Preferences.userId, 'id': id, 'idrelated': idrelated},
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        return false;
      }

      final data = jsonDecode(response.body);

      return data['success'] == true;
    } catch (e) {
      debugPrint('Error eliminando libro relacionado: $e');
      return false;
    }
  }

  Future<List<Book>> getRelatedBooks({required String id}) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlRelatedGet),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'userId': Preferences.userId, 'id': id},
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        return [];
      }

      final data = jsonDecode(response.body);

      if (data['success'] != true) {
        return [];
      }

      final List<dynamic> booksJson = data['books'];

      return booksJson.map((json) {
        return Book.fromMap(json);
      }).toList();
    } catch (e) {
      debugPrint('Error obteniendo libros relacionados: $e');
      return [];
    }
  }

  static Future<String?> getUserId(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlUser),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email},
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return data['id'];
        }
      }
    } catch (e) {
      debugPrint('Error obteniendo usuario: $e');
    }

    return null;
  }

  static Future<bool> updateEmail() async {
    try {
      final response = await http.post(
        Uri.parse(Secret.urlUpdateEmail),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': Preferences.userId, 'email': Preferences.email},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
    } catch (e) {
      debugPrint('Error actualizando email: $e');
    }

    return false;
  }
}
