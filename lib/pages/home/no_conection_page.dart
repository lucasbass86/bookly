import 'package:bookly/pages/pages.dart';
import 'package:bookly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoConnectionPage extends StatefulWidget {
  static const String routeName = 'NoConnectionPage';
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  bool isPressd = false;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (Utils.isConnected && isPressd && context.mounted) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
    return SafeArea(
      child: Scaffold(
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
          actions: [
            IconButton(
              onPressed: () => SystemNavigator.pop(),
              icon: Icon(Icons.power_settings_new_rounded),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 200),
              Container(
                margin: const EdgeInsets.only(bottom: 80),
                height: 40,
                child: Center(
                  child: Text(
                    'No hay conexión',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                  onPressed: () => Utils.checkConnection().then((value) {
                    if (value) {
                      isPressd = true;
                      setState(() {});
                    }
                  }),
                  child: Text('Reintentar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
