import 'package:bookly/utils/enums.dart';
import 'package:bookly/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CategoryFilterWidget extends StatefulWidget {
  final List<BookCategory> categories;
  final BookCategory? selectedCategory;

  const CategoryFilterWidget({super.key, required this.categories, required this.selectedCategory});

  @override
  State<CategoryFilterWidget> createState() => _CategoryFilterStateWidget();
}

class _CategoryFilterStateWidget extends State<CategoryFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [...widget.categories.map((c) => CategoryWidget(category: c))],
    );
  }
}
