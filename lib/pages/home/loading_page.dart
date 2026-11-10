import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  static const String routeName = 'LoadingPage';
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mi biblioteca', style: TextStyle(fontSize: 35)),
            Text(
              'Mis libros, siempre conmigo',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Cargando...', style: TextStyle(fontSize: 23)),
          ],
        ),
      ),
    );
  }
}
