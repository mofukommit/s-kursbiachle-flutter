import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ManageEntries extends StatefulWidget {
  const ManageEntries({Key? key, required this.entries}) : super(key: key);
  final Set<DateTime> entries;

  @override
  _ManageEntries createState() => _ManageEntries();
}

class _ManageEntries extends State<ManageEntries> {

  List<bool> _allDay = List.generate(2, (_) => false);

  @override
  void initState(){
    super.initState();
    print(widget.entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.kommit,
            title: saveEntries(context),
            centerTitle: true),
        body: dateSettings(context)
    );
  }

  Widget saveEntries(BuildContext context){
    return Row(
      children: [
        Spacer(),
        const Text("Verfügbarkeiten"),
        Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red.shade300
          ),
            onPressed: () {
                // so the stuff
            },
            child: Text("Speichern")
        )
      ],
    );
  }

  Widget dateSettings(BuildContext context){

    Column l = Column(children: [
      Container(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Row(
          children: [
            Text('Alle Tage den ganzen Tag'),
            Spacer(),
            ToggleButtons(
              children: <Widget>[
                Icon(Icons.check),
                Icon(Icons.close),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < _allDay.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      _allDay[buttonIndex] = true;
                    } else {
                      _allDay[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: _allDay,
            ),
          ],
        ),
      )
    ],
    );

    for(var entry in widget.entries){
      l.children.add(
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 8,
            shadowColor: Colors.kommit,
            child: ExpansionTile(
                title: Text('${DateFormat('dd.MM.yyyy').format(entry)}'),
                children: [
                  Text('$entry')
                ],
            ),
          )
      );
    }

    return l;
  }
}