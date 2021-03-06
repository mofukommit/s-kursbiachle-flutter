// Packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:skursbiachle/pages/subpages/authorized.dart';
import 'package:skursbiachle/pages/subpages/pupil_detail.dart';
import 'package:skursbiachle/root.dart';
// Pages
import 'pages/closing.dart';
import 'pages/course.dart';
import 'pages/scanner.dart';
import 'pages/search.dart';
import 'pages/settings.dart';
import 'pages/subpages/course_details.dart';
import 'pages/subpages/pupil_check.dart';

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient( context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = new PostHttpOverrides();
  initializeDateFormatting('de_DE').then((_) => runApp(const MyApp()));
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
        // Navpages
        "/search" : (BuildContext context) => const Search(),
        "course" : (BuildContext context) => const Course(),
        "/scanner": (BuildContext context) => const Scanner(),
        "/closing" : (BuildContext context) => const Closing(),
        "/settings": (BuildContext context) => const Settings(),
        // Subpages
        "/pupilCheck": (context) => PupilCheck(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        "/courseDetails": (context) => CourseDetails(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        "/pupilDetail": (context) => PupilDetail(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        "/authorized": (context) => Authorized(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        },
      home: const RootWidget(),
    );
  }
}