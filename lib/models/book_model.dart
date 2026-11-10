import 'dart:convert';

import 'package:bookly/secrets/secrets.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/utils.dart';

class Book {
  final String userId;
  final String id;
  final String? title;
  final String? author;
  final BookCategory category;
  final String? publisher;
  final String? publishYear;
  final int? pages;
  final String? isbn;
  final String? observations;
  final BookState state;
  final String? coverUrl;

  @override
  String toString() => '$author: $title';

  String get cover => coverUrl != null && coverUrl!.isNotEmpty ? '${Secret.urlCover}$coverUrl' : '';

  Book({
    required this.userId,
    required this.title,
    required this.author,
    required this.category,
    required this.publisher,
    required this.publishYear,
    required this.pages,
    required this.isbn,
    required this.observations,
    required this.state,
    this.coverUrl,
  }) : id = Utils.uuid();

  Book.withId({
    required this.userId,
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.publisher,
    required this.publishYear,
    required this.pages,
    required this.isbn,
    required this.observations,
    required this.state,
    required this.coverUrl,
  });

  Book copyWith({
    String? userId,
    String? id,
    String? title,
    String? author,
    BookCategory? category,
    String? publisher,
    String? publishYear,
    int? pages,
    String? isbn,
    String? observations,
    BookState? state,
    String? coverUrl,
  }) {
    return Book.withId(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      publisher: publisher ?? this.publisher,
      publishYear: publishYear ?? this.publishYear,
      pages: pages ?? this.pages,
      isbn: isbn ?? this.isbn,
      observations: observations ?? this.observations,
      state: state ?? this.state,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'author': author,
      'category': category.name,
      'publisher': publisher,
      'publishYear': publishYear,
      'pages': pages,
      'isbn': isbn,
      'observations': observations,
      'state': state.name,
      'coverUrl': coverUrl,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book.withId(
      userId: map['userId'] ?? '',
      id: map['id'] ?? '',
      title: map['title'],
      author: map['author'],
      category: BookCategory.values.byName(map['category']),
      publisher: map['publisher'],
      publishYear: map['publishYear'],
      pages: map['pages']?.toInt(),
      isbn: map['isbn'],
      observations: map['observations'],
      coverUrl: map['coverUrl'],
      state: BookState.values.byName(map['state']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));
}
