import 'dart:convert';
import 'package:bookly/models/models.dart';
import 'package:bookly/secrets/secrets.dart';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  /// Busca un libro por ISBN (acepta ISBN-10 o ISBN-13)
  /// Devuelve el primer resultado o null si no encuentra nada.
  static Future<Google?> getBookByIsbn(String isbn) async {
    // Limpia el ISBN (quita guiones y espacios)
    final cleanIsbn = isbn.replaceAll(RegExp(r'[^0-9X]'), '');

    final url = Uri.parse('${Secret.googleUrl}?q=isbn:$cleanIsbn&key=${Secret.googleApiKey}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['totalItems'] != null && data['totalItems'] > 0) {
          final items = data['items'] as List;
          return Google.fromJson(items.first);
        } else {
          return null; // No se encontró el libro
        }
      } else {
        return null;
        // throw Exception('Error en la API: ${response.statusCode}');
      }
    } catch (e) {
      return null;
      // throw Exception('Error al buscar el libro: $e');
    }
  }

  /// Versión que devuelve una lista (por si hay varios resultados)
  static Future<List<Google>> searchBooksByIsbn(String isbn) async {
    final cleanIsbn = isbn.replaceAll(RegExp(r'[^0-9X]'), '');
    final url = Uri.parse('${Secret.googleUrl}?q=isbn:$cleanIsbn&key=${Secret.googleApiKey}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List? ?? [];

      return items.map((item) => Google.fromJson(item)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
