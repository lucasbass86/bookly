class OpenLibrary {
  final String? url;
  final String? key;
  final String? title;
  final String? subtitle;
  final List<OpenLibraryAuthor> authors;
  final int? numberOfPages;
  final OpenLibraryIdentifiers? identifiers;
  final List<OpenLibraryPublisher> publishers;
  final String? publishDate;
  final OpenLibraryCover? libraryCover;

  const OpenLibrary({
    this.url,
    this.key,
    this.title,
    this.subtitle,
    this.authors = const [],
    this.numberOfPages,
    this.identifiers,
    this.publishers = const [],
    this.publishDate,
    this.libraryCover,
  });

  String get cover {
    if (libraryCover == null) return '';
    if (libraryCover?.large != null) {
      return libraryCover!.large!;
    } else if (libraryCover?.medium != null) {
      return libraryCover!.medium!;
    } else if (libraryCover!.small != null) {
      return libraryCover!.small!;
    } else {
      return '';
    }
  }

  factory OpenLibrary.fromJson(Map<String, dynamic> json) {
    return OpenLibrary(
      url: json['url'],
      key: json['key'],
      title: json['title'],
      subtitle: json['subtitle'],
      authors:
          (json['authors'] as List<dynamic>?)?.map((e) => OpenLibraryAuthor.fromJson(e)).toList() ??
          [],
      numberOfPages: json['number_of_pages'],
      identifiers: json['identifiers'] != null
          ? OpenLibraryIdentifiers.fromJson(json['identifiers'])
          : null,
      publishers:
          (json['publishers'] as List<dynamic>?)
              ?.map((e) => OpenLibraryPublisher.fromJson(e))
              .toList() ??
          [],
      publishDate: json['publish_date'],
      libraryCover: json['cover'] != null ? OpenLibraryCover.fromJson(json['cover']) : null,
    );
  }
}

class OpenLibraryAuthor {
  final String? url;
  final String? name;

  const OpenLibraryAuthor({this.url, this.name});

  factory OpenLibraryAuthor.fromJson(Map<String, dynamic> json) {
    return OpenLibraryAuthor(url: json['url'], name: json['name']);
  }
}

class OpenLibraryPublisher {
  final String? name;

  const OpenLibraryPublisher({this.name});

  factory OpenLibraryPublisher.fromJson(Map<String, dynamic> json) {
    return OpenLibraryPublisher(name: json['name']);
  }
}

class OpenLibraryIdentifiers {
  final List<String> isbn13;
  final List<String> openLibrary;

  const OpenLibraryIdentifiers({this.isbn13 = const [], this.openLibrary = const []});

  factory OpenLibraryIdentifiers.fromJson(Map<String, dynamic> json) {
    return OpenLibraryIdentifiers(
      isbn13: (json['isbn_13'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      openLibrary: (json['openlibrary'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class OpenLibraryCover {
  final String? small;
  final String? medium;
  final String? large;

  const OpenLibraryCover({this.small, this.medium, this.large});

  factory OpenLibraryCover.fromJson(Map<String, dynamic> json) {
    return OpenLibraryCover(small: json['small'], medium: json['medium'], large: json['large']);
  }
}
