import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class IsbnScannerPage extends StatefulWidget {
  static final String routeName = 'IsbnScannerPage';
  const IsbnScannerPage({super.key});

  @override
  State<IsbnScannerPage> createState() => _IsbnScannerPageState();
}

class _IsbnScannerPageState extends State<IsbnScannerPage> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pop(context, ''),
          child: const Text('Escanear ISBN'),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_scanned) return;
              for (final barcode in capture.barcodes) {
                final value = barcode.rawValue;
                if (value != null && RegExp(r'^(97[89])\d{10}$').hasMatch(value)) {
                  _scanned = true;
                  Navigator.pop(context, value);
                  return;
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 280,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Text(
              'Coloca el código de barras del libro '
              'dentro del recuadro',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
