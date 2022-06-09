// Packages
import 'package:flutter/material.dart';
import 'package:skursbiachle/root.dart';
// Pages
import 'pages/closing.dart';
import 'pages/course.dart';
import 'pages/scanner.dart';
import 'pages/search.dart';
import 'pages/settings.dart';
import 'pages/subpages/pupil_check.dart';

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
      // start app on page initialRoute
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        "/search" : (BuildContext context) => Search(),
        "/course" : (BuildContext context) => const Course(),
        "/QrCodeScanner": (BuildContext context) => const QrCodeScanner(),
        "/closing" : (BuildContext context) => const Closing(),
        "/settings": (BuildContext context) => const Settings(),
        "/PupilCheck": (context) => PupilCheck(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        },
      home: const RootWidget(),
    );
  }
}