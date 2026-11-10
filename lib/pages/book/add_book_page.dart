import 'dart:io';

import 'package:bookly/dialogs/dialogs.dart';
import 'package:bookly/helpers/helper.dart';
import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:bookly/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  static const String routeName = 'AddBookPage';
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  File? _coverImage;
  String? _recognizedText;
  bool isGettingData = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Añadir libro')),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: !isGettingData
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(Icons.camera_alt, size: 100)),
                  ),
                  20.h,
                  Text(
                    'Toma una foto de la portada',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                  ),
                  10.h,
                  Text(
                    'La imagen se usará como portada de tu libro',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  20.h,
                  ElevatedButton(
                    onPressed: () async {
                      File? file = await Helper.takeCoverPhoto(context);
                      if (file != null && context.mounted) {
                        _coverImage = file;
                        String? reco = await Helper.recognizeText(context, file.path);
                        if (reco != null) {
                          _recognizedText = reco;
                          if (!context.mounted) return;
                          final BookCoverResult? result = await _bookData(context);
                          _titleController.text = '';
                          _authorController.text = '';
                          if (result != null && context.mounted) {
                            await Navigator.pushNamed(
                              context,
                              NewBookPage.routeName,
                              arguments: result,
                            );
                            if (context.mounted) Navigator.pop(context);
                          }
                        }
                      }
                    },
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 35),
                        Text('Hacer foto', style: TextStyle(fontSize: 21)),
                      ],
                    ),
                  ),
                  10.h,
                  OutlinedButton(
                    onPressed: () async {
                      final String isbn =
                          await Navigator.pushNamed(context, IsbnScannerPage.routeName) as String;
                      // String isbn = '9788418037016'; //HAIL MARY
                      // String isbn = '9791387690595'; //REY DOLOR
                      // String isbn = '9791388204203'; //VASTAGO
                      // String isbn = '9788410466470'; //FRENOPATICA
                      // String isbn = '9788410466388'; //MASCARADA
                      // String isbn = '9788410466364'; //PORTAL
                      // String isbn = '9788410466166'; //ANARQUISTA
                      // String isbn = '9788410466081'; //JUICIO FINAL
                      // String isbn = '9788410466135'; //CARL

                      if (!context.mounted || isbn.isEmpty) return;

                      //COMPROBAR PRIMERO SI YA EXISTE:
                      if (await Helper.checkBookExists(context, isbn)) return;
                      if (!context.mounted) return;

                      final resp = await searchApisDialog(context, isbn);
                      if (resp != null && context.mounted) {
                        final chooseBook = await Navigator.pushNamed(
                          context,
                          PreviewBookPage.routeName,
                          arguments: resp,
                        );
                        if (chooseBook != null && context.mounted) {
                          await Navigator.pushNamed(
                            context,
                            NewBookPage.routeName,
                            arguments: chooseBook,
                          );
                        }

                        if (context.mounted) Navigator.pop(context);
                      } else if (context.mounted) {
                        Utils.snackBar(context, 'No se ha encontrado 😱', isBad: true);
                      }
                    },
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner_rounded, size: 35),
                        Text('Escanear', style: TextStyle(fontSize: 21)),
                      ],
                    ),
                  ),
                  10.h,
                  OutlinedButton(
                    onPressed: () async {
                      File? file = await Helper.pickCoverFromGallery(context);
                      if (file != null && context.mounted) {
                        _coverImage = file;
                        String? reco = await Helper.recognizeText(context, file.path);
                        if (reco != null) {
                          _recognizedText = reco;
                          if (!context.mounted) return;
                          final BookCoverResult? result = await _bookData(context);
                          _titleController.text = '';
                          _authorController.text = '';
                          if (result != null && context.mounted) {
                            await Navigator.pushNamed(
                              context,
                              NewBookPage.routeName,
                              arguments: result,
                            );
                            if (context.mounted) Navigator.pop(context);
                          }
                        }
                      }
                    },
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_size_select_actual_outlined, size: 35),
                        Text('Elegir de la galería', style: TextStyle(fontSize: 21)),
                      ],
                    ),
                  ),
                  30.h,
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(child: Container(height: 1, color: AppColors.pending)),
                      Text('o'),
                      Expanded(child: Container(height: 1, color: AppColors.pending)),
                    ],
                  ),
                  30.h,
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, NewBookPage.routeName);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, size: 35),
                        Text('Añadir manualmente', style: TextStyle(fontSize: 21)),
                      ],
                    ),
                  ),
                ],
              )
            : LoadingWidget(),
      ),
    );
  }

  Future<BookCoverResult?> _bookData(BuildContext context) {
    String? captureText = _recognizedText;
    return showModalBottomSheet(
      showDragHandle: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Datos obtenidos',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                    ),
                    20.h,
                    if (_coverImage != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          child: Image.file(
                            _coverImage!,
                            height: 220,
                            width: 150,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    20.h,
                    _buildOcrTextField(
                      label: 'Título',
                      controller: _titleController,
                      hintText: 'Introduce el título del libro',
                      onAccept: (value) =>
                          setState(() => captureText = captureText!.replaceAll(value, '')),
                    ),
                    const SizedBox(height: 20),
                    _buildOcrTextField(
                      label: 'Autor',
                      controller: _authorController,
                      hintText: 'Introduce el autor del libro',
                      onAccept: (value) =>
                          setState(() => captureText = captureText!.replaceAll(value, '')),
                    ),
                    20.h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Texto reconocido:',
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              captureText = _recognizedText;
                            });
                          },
                          icon: Icon(Icons.restart_alt_rounded),
                        ),
                      ],
                    ),
                    20.h,
                    if (captureText != null)
                      ...captureText!.split('\n').where((line) => line.trim().isNotEmpty).map((
                        line,
                      ) {
                        final text = line.trim();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Draggable<String>(
                            data: text,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(text, style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                            childWhenDragging: Opacity(opacity: 0.3, child: _buildOcrLine(text)),
                            child: _buildOcrLine(text),
                          ),
                        );
                      }),
                    40.h,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(
                          context,
                          BookCoverResult(
                            titulo: _titleController.text.trim(),
                            autor: _authorController.text.trim(),
                            imagen: _coverImage,
                          ),
                        ),
                        child: Text('Continuar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOcrLine(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildOcrTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required Function(String) onAccept,
  }) {
    bool isAdding = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        DragTarget<String>(
          onAcceptWithDetails: (details) {
            if (isAdding) {
              controller.text += ' ${details.data}';
            } else {
              controller.text = details.data;
            }
            controller.selection = TextSelection.collapsed(offset: controller.text.length);
            onAccept.call(details.data);
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isHovering ? AppColors.readBackground : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHovering ? AppColors.read : AppColors.border,
                      width: isHovering ? 3 : 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      prefixIcon: const Icon(Icons.edit_outlined, size: 20),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => isAdding = !isAdding),
                        child: Icon(isAdding ? Icons.remove : Icons.add, size: 20),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
