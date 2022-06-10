// BottomNavigationBar
import 'package:flutter/material.dart';
// Pages
import 'pages/closing.dart';
import 'pages/course.dart';
import 'pages/scanner.dart';
import 'pages/search.dart';
import 'pages/settings.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
          index: _currentIndex,
          children: const [
            Course(),
            Search(),
            QrCodeScanner(),
            Closing(),
            Settings(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Kurse",
              backgroundColor: Colors.kommit,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Suche",
              backgroundColor: Colors.kommit,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: "QR-Code",
              backgroundColor: Colors.kommit,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_rounded),
              label: "Tagesabschluss",
              backgroundColor: Colors.kommit,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Einstellungen",
              backgroundColor: Colors.kommit,
            ),
          ]),
    );
  }
}
