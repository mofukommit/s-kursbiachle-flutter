import 'package:flutter/material.dart';
import 'package:skursbiachle/root.dart';
import 'pages/closing.dart';
import 'pages/course.dart';
import 'pages/qrcodescanner.dart';
import 'pages/search.dart';
import 'pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {
        "/search" : (BuildContext context) => const Search(),
        "/course" : (BuildContext context) => const Course(),
        "/QrCodeScanner": (BuildContext context) => const QrCodeScanner(),
        "/closing" : (BuildContext context) => const Closing(),
        "/settings": (BuildContext context) => const Settings(),
      },
      home: const RootWidget(),
    );
  }
}

