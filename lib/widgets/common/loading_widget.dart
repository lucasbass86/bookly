import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? title;
  const LoadingWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          CircularProgressIndicator(),
          Text(title ?? 'Obteniendo información...', style: TextStyle(fontSize: 21)),
        ],
      ),
    );
  }
}
