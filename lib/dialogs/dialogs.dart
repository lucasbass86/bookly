import 'package:bookly/helpers/helper.dart';
import 'package:bookly/models/models.dart';
import 'package:bookly/theme/theme.dart';
import 'package:flutter/material.dart';

Future<dynamic> showMessage({
  required BuildContext context,
  Widget? header,
  required String title,
  String? subtitle,
  String aceptText = 'Aceptar',
  String cancelText = 'Cancelar',
  bool showCancel = true,
  Color? aceptColor,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (header != null) header,
            Text(
              title,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(aceptColor)),
              onPressed: () => Navigator.pop(context, true),
              child: Text(aceptText),
            ),
          ),
          if (showCancel)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelText),
              ),
            ),
        ],
      );
    },
  );
}

Future<bool> showSlideToUnlock(
  BuildContext context, {
  Color backColor = const Color.fromRGBO(224, 224, 224, 1),
  Color slideColor = Colors.blue,
  Color slideColorEnd = Colors.green,
  String text = 'Desliza para confirmar',
  Color textColor = Colors.white,
  IconData iconData = Icons.arrow_forward,
}) async {
  final unlocked = await showModalBottomSheet(
    showDragHandle: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      double offset = 0.0;
      bool unlocked0 = false;
      return StatefulBuilder(
        builder: (context, setState) {
          final width = MediaQuery.of(context).size.width - 32;
          final maxOffset = width - 80;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 1.0 - (offset / maxOffset),
                        child: Text(text, style: TextStyle(color: textColor)),
                      ),
                    ),
                    Positioned(
                      left: offset,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            offset += details.delta.dx;
                            if (offset < 0) offset = 0;
                            if (offset > maxOffset) offset = maxOffset;
                          });
                        },
                        onHorizontalDragEnd: (_) {
                          if (offset > maxOffset * 0.9) {
                            setState(() {
                              unlocked0 = true;
                              offset = maxOffset;
                            });
                            Navigator.of(context).pop(true);
                          } else {
                            setState(() {
                              offset = 0;
                            });
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: unlocked0 ? slideColorEnd : slideColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: unlocked0
                              ? Icon(Icons.check_rounded, color: Colors.white)
                              : Icon(iconData, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return unlocked == true;
}

Future<dynamic> searchApisDialog(BuildContext context, String isbn) async {
  int currentApi = 0;
  List<bool> found = [true, true, true];
  late StateSetter setDialogState;
  OpenLibrary? openLibrary;
  Google? google;
  HardcoverBook? hardcoverBook;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          setDialogState = setState;
          Widget apiStatus(int index, String name) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: index == currentApi ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (index < currentApi && found[index])
                  Icon(Icons.check_circle, color: Colors.green[300])
                else if (index < currentApi && !found[index])
                  Icon(Icons.emergency_rounded, color: Colors.red[300])
                else if (index == currentApi)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                else
                  const Icon(Icons.hourglass_empty, color: Colors.grey),
              ],
            );
          }

          return AlertDialog(
            title: const Text(
              'Buscando libro',
              style: TextStyle(color: AppColors.primary, fontSize: 21),
            ),
            content: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                apiStatus(0, 'OpenLibrary'),
                apiStatus(1, 'Google'),
                apiStatus(2, 'Hardcover'),
              ],
            ),
          );
        },
      );
    },
  );
  try {
    openLibrary = await Helper.scanOpenLibrary(context, isbn);
    if (openLibrary == null) {
      found[0] = false;
    }
    currentApi = 1;
    setDialogState(() {});

    if (!context.mounted) return;

    google = await Helper.scanGoogle(context, isbn);
    if (google == null) {
      found[1] = false;
    }

    currentApi = 2;
    setDialogState(() {});

    if (!context.mounted) return;
    hardcoverBook = await Helper.scanHardcover(context, isbn);

    if (hardcoverBook == null) {
      found[2] = false;
    }
    currentApi = 3;
    setDialogState(() {});
    await Future.delayed(const Duration(seconds: 1));
  } finally {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
  if (!found.any((e) => e)) return null;
  return [openLibrary, google, hardcoverBook];
}
