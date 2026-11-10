import 'package:bookly/utils/enums.dart';
import 'package:flutter/material.dart';

class BookStateWidget extends StatelessWidget {
  final BookState state;
  const BookStateWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: state.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: state.color),
          ),
          Text(
            state.displayName,
            style: TextStyle(color: state.color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
