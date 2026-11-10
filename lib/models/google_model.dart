class Google {
  final String id;
  final String title;
  final List<String> authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final int? pageCount;
  final String? thumbnail;
  final String? isbn10;
  final String? isbn13;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;

  Google({
    required this.id,
    required this.title,
    required this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.pageCount,
    this.thumbnail,
    this.isbn10,
    this.isbn13,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
  });

  factory Google.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final industryIdentifiers = volumeInfo['industryIdentifiers'] as List? ?? [];

    String? isbn10;
    String? isbn13;

    for (var id in industryIdentifiers) {
      if (id['type'] == 'ISBN_10') {
        isbn10 = id['identifier'];
      } else if (id['type'] == 'ISBN_13') {
        isbn13 = id['identifier'];
      }
    }

    return Google(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Sin título',
      authors: List<String>.from(volumeInfo['authors'] ?? ['Autor desconocido']),
      publisher: volumeInfo['publisher'],
      publishedDate: volumeInfo['publishedDate'],
      description: volumeInfo['description'],
      pageCount: volumeInfo['pageCount'],
      thumbnail: imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'],
      isbn10: isbn10,
      isbn13: isbn13,
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      averageRating: (volumeInfo['averageRating'] as num?)?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'],
    );
  }
}
