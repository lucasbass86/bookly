import 'package:bookly/pages/pages.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  HomePage.routeName: (_) => HomePage(),
  SearchPage.routeName: (_) => SearchPage(),
  AddBookPage.routeName: (_) => AddBookPage(),
  NewBookPage.routeName: (_) => NewBookPage(),
  BookDetailPage.routeName: (_) => BookDetailPage(),
  IsbnScannerPage.routeName: (_) => IsbnScannerPage(),
  CoverDetailPage.routeName: (_) => CoverDetailPage(),
  SettingsPage.routeName: (_) => SettingsPage(),
  UpdatePage.routeName: (_) => UpdatePage(),
  PreviewBookPage.routeName: (_) => PreviewBookPage(),
  NoConnectionPage.routeName: (_) => NoConnectionPage(),
  LoadingPage.routeName: (_) => LoadingPage(),
};
