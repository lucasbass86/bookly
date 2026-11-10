import 'package:bookly/providers/providers.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:flutter/material.dart';

class StateWidget extends StatelessWidget {
  final BookState state;
  const StateWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of(context);
    return GestureDetector(
      onTap: () => mainProvider.state = state,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: mainProvider.state == state ? AppColors.primaryDark : AppColors.border,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          state.displayName,
          style: TextStyle(
            color: mainProvider.state == state ? AppColors.background : AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
