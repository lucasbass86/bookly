import 'dart:convert';
import 'package:bookly/models/models.dart';
import 'package:bookly/secrets/secrets.dart';
import 'package:http/http.dart' as http;

class HardcoverService {
  static Future<List<HardcoverBook>?> searchBooks(String query) async {
    const graphQLQuery = r'''
      query SearchBooks($query: String!) {
        search(query: $query) {
          results
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(Secret.endpointHardcover),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Secret.apiTokenHardcover}',
      },
      body: jsonEncode({
        'query': graphQLQuery,
        'variables': {'query': query},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body);

    final hits = json['data']['search']['results']['hits'] as List<dynamic>;

    List<HardcoverBook> hits2 = hits.map((e) => HardcoverBook.fromJson(e)).toList();
    return hits2;
  }
}
