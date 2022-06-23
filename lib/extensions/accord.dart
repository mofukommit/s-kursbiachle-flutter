import 'dart:ffi';

import 'package:flutter/material.dart';

class Accordione extends StatefulWidget {
  final String title;
  final Widget content;

  const Accordione({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordione> {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.kommit,
      margin: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showContent = !_showContent;
          });
        },
        child: Column(children: [
          ListTile(
            title: Text(widget.title),
            trailing: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ),
          _showContent
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: widget.content,
                )
              : Container()
        ]),
      ),
    );
  }
}
