import 'package:bookly/providers/providers.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final BookCategory category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of(context);
    return GestureDetector(
      onTap: () => mainProvider.category = category,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: mainProvider.category == category ? AppColors.primaryDark : AppColors.border,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category.displayName,
          style: TextStyle(
            color: mainProvider.category == category ? AppColors.background : AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
