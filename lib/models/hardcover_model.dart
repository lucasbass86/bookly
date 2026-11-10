class HardcoverBook {
  final String id;
  final String title;
  final String? subtitle;
  final String? author;
  final String? description;
  final String? imageUrl;
  final List<String> isbns;
  final List<String> genres;
  final int? pages;
  final double? rating;
  final int? ratingsCount;
  final DateTime? releaseDate;

  @override
  String toString() => title;

  HardcoverBook({
    required this.id,
    required this.title,
    this.subtitle,
    this.author,
    this.description,
    this.imageUrl,
    required this.isbns,
    required this.genres,
    this.pages,
    this.rating,
    this.ratingsCount,
    this.releaseDate,
  });

  factory HardcoverBook.fromJson(Map<String, dynamic> hit) {
    final doc = hit['document'];

    return HardcoverBook(
      id: doc['id'].toString(),
      title: doc['title'] ?? '',
      subtitle: doc['subtitle'],
      author: (doc['author_names'] as List?)?.isNotEmpty == true ? doc['author_names'][0] : null,
      description: doc['description'],
      imageUrl: doc['image']?['url'],
      isbns: List<String>.from(doc['isbns'] ?? []),
      genres: List<String>.from(doc['genres'] ?? []),
      pages: doc['pages'],
      rating: (doc['rating'] as num?)?.toDouble(),
      ratingsCount: doc['ratings_count'],
      releaseDate: doc['release_date'] != null ? DateTime.tryParse(doc['release_date']) : null,
    );
  }
}
