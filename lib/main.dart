import 'package:bookly/pages/pages.dart';
import 'package:bookly/preferences/preferences.dart';
import 'package:bookly/routers/routers.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Preferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => BookService(), lazy: true),
      ],
      child: FutureBuilder(
        future: Utils.checkConnection(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isConnected = snapshot.data as bool;
            if (isConnected) {
              return const MyApp();
            } else {
              return const MyAppNoConnection();
            }
          } else {
            return const MyAppLoading();
          }
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: routes,
      initialRoute: HomePage.routeName,
    );
  }
}

class MyAppNoConnection extends StatelessWidget {
  const MyAppNoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: routes,
      initialRoute: NoConnectionPage.routeName,
    );
  }
}

class MyAppLoading extends StatelessWidget {
  const MyAppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: routes,
      initialRoute: LoadingPage.routeName,
    );
  }
}
