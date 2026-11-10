import 'package:bookly/utils/enums.dart';

class AdvancedSearch {
  final String toSearch;
  final Search type;

  @override
  String toString() => '$type: $toSearch';

  AdvancedSearch({required this.toSearch, required this.type});
}
