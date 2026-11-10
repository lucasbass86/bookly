import 'dart:convert';
import 'package:bookly/models/models.dart';
import 'package:http/http.dart' as http;

class BookSearchService {
  static const String _baseUrl = 'https://openlibrary.org/api/books';

  static Future<OpenLibrary?> searchByIsbn(String isbn) async {
    final cleanIsbn = isbn.replaceAll(RegExp(r'[^0-9Xx]'), '').toUpperCase();

    if (cleanIsbn.isEmpty) return null;

    final uri = Uri.parse(
      _baseUrl,
    ).replace(queryParameters: {'bibkeys': 'ISBN:$cleanIsbn', 'format': 'json', 'jscmd': 'data'});

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error consultando Open Library: ${response.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    final bookData = json['ISBN:$cleanIsbn'];

    if (bookData == null) return null;

    final OpenLibrary openLibrary = OpenLibrary.fromJson(Map<String, dynamic>.from(bookData));
    return openLibrary;
  }
}
