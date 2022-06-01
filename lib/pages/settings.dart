import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.kommit,
          title: const Text("Einstellungen"),
          centerTitle: true),
      body: const Placeholder(),
    );
  }
}
