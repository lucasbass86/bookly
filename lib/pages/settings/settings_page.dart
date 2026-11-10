import 'package:bookly/dialogs/dialogs.dart';
import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/preferences/preferences.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = 'SettingsPage';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Configuración')),
        actions: [IconButton(onPressed: () => _info(context), icon: Icon(Icons.info_outline))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 40,
          children: [_changeEmail(context), _eraseData(context)],
        ),
      ),
    );
  }

  Widget _changeEmail(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: Preferences.email);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Registrado con:', style: TextStyle(fontSize: 21, color: AppColors.primary)),
        10.h,
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  maxLength: 100,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(counterText: ''),
                  readOnly: true,
                ),
                20.h,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final resp = await LicenseService.checkUpdateLicense(context);
                      if (resp) {
                        final change = await BookService.updateEmail();
                        if (change && context.mounted) {
                          Utils.showSnackBar(context, 'Email actualizado');
                          setState(() {});
                        }
                      }
                    },
                    child: Text('Cambiar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _eraseData(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Borrado de datos:', style: TextStyle(fontSize: 21, color: AppColors.primary)),
        10.h,
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Borrado de todos los datos',
                  style: TextStyle(fontSize: 17, color: AppColors.error),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final Widget header = Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error.withAlpha(100),
                      ),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Icon(Icons.delete, color: AppColors.background),
                      ),
                    );
                    final n1 = await showMessage(
                      context: context,
                      title: '¿Borrar todos los datos?',
                      showCancel: true,
                      header: header,
                      subtitle: 'Esta acción es IRREVERSIBLE',
                      aceptColor: AppColors.error,
                    );
                    if (n1 != null && n1 && context.mounted) {
                      final n2 = await showSlideToUnlock(
                        context,
                        slideColor: AppColors.primaryLight,
                        textColor: AppColors.primaryDark,
                      );
                      if (n2 && context.mounted) {
                        final n3 = await showMessage(
                          context: context,
                          header: header,
                          aceptColor: AppColors.error,
                          title: '¿Confirma que desea borrar los datos?',
                          subtitle: 'Esta acción es DEFINITIVA',
                        );
                        if (n3 != null && n3 && context.mounted) {
                          final BookService bookService = Provider.of(context, listen: false);
                          for (Book b in bookService.books) {
                            bookService.deleteBook(b);
                          }
                          Utils.showSnackBar(context, 'Datos borrados definitivamente 😢');
                        }
                      }
                    }
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _info(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: false,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Información', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
              10.h,
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Licencia: ${Preferences.license}', style: TextStyle(fontSize: 17)),
                        Divider(),
                        FutureBuilder(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              PackageInfo packageInfo = snapshot.data as PackageInfo;
                              return Text(
                                'Version: ${packageInfo.version}',
                                style: TextStyle(fontSize: 17),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
