import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../services/post/post_settings/manage_entries.dart';
import './utils.dart';


class Availability extends StatefulWidget {
  @override
  _Availability createState() => _Availability();
}

class _Availability extends State<Availability> {

  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  DateTime kFirstDay = DateTime.parse('2022-01-01');
  DateTime kLastDay = DateTime.now().add(Duration(days: 150));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.kommit,
          title: const Text("Verfügbarkeiten"),
          centerTitle: true),
      body: Column(
      children: [
        TableCalendar<Event>(
          locale: 'de_DE',
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            // Use values from Set to mark multiple days as selected
            return _selectedDays.contains(day);
          },
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarBuilders: CalendarBuilders(
            singleMarkerBuilder: (context, date, _) {
              return Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: date == _selectedDays ? Colors.white : Colors.green), //Change color
                width: 5.0,
                height: 5.0,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
              );
            }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(160, 50),
                  primary: Colors.kommit.shade400
              ),
              child: Text('Auswahl \n aufheben', textAlign: TextAlign.center),
              onPressed: () {
                setState(() {
                  _selectedDays.clear();
                  _selectedEvents.value = [];
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(160, 50),
                  primary: Colors.red.shade300
              ),
              child: Text('Verfügbarkeiten \n eintragen', textAlign: TextAlign.center),
              onPressed: (){
                if(_selectedDays.isNotEmpty){
                  // print(_selectedDays);
                  // print(_selectedDays.runtimeType);
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ManageEntries(entries: _selectedDays)
                    ),
                  );
                  
                } else {
                  print('NOTHING SELECTEd');
                  // show an overlay message
                }
              },
            ),
            Spacer(),
          ],
        ),

        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index]}'),
                      title: Text('${value[index]}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}