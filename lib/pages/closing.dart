import 'package:flutter/material.dart';

class Closing extends StatelessWidget {
  const Closing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.kommit,
          title: const Text("Tagesabschluss"),
          centerTitle: true),
      body: const Placeholder(),
    );
  }
}
