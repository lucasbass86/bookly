import 'dart:io';

class BookCoverResult {
  final String titulo;
  final String autor;
  final File? imagen;

  @override
  String toString() => '$autor-$titulo';

  const BookCoverResult({required this.titulo, required this.autor, required this.imagen});
}
