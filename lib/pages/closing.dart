import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:skursbiachle/database/courses_database.dart';
import 'package:skursbiachle/extensions/write_files.dart';
import 'package:skursbiachle/model/courses.dart';
import 'package:skursbiachle/services/daily_closure.dart';

import '../database/teacher_database.dart';
import '../extensions/ColorConvert.dart';
import '../model/teacher.dart';
import 'course.dart';

class Closing extends StatefulWidget {
  const Closing({Key? key}) : super(key: key);

  @override
  ClosingState createState() => ClosingState();
}

class ClosingState extends State<Closing> {
  var isLoaded = false;
  List<CourseDB>? dailyList;

  @override
  void initState() {
    super.initState();
    check_if_registered().then((result) {
      if (result == true) {
        //fetch data from API
        getDatabase();
      }
    });
  }

  check_if_registered() async {
    late KeyDB key;
    try {
      key = await KeyDatabase.instance.readKey(1);
    } on Exception {
      return false;
    }
    if (key.costumerKey != '') {
      return true;
    } else {
      return false;
    }
  }

  void getDatabase() async {
    dailyList = await CoursesDatabase.instance.getDailyClosings();
    setState(() {
      isLoaded = true;
    });
  }

  Future refresh() async {
    setState(() {
      dailyList?.clear();
      getDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.kommit,
            title: const Text("Tagesabschluss"),
            centerTitle: true),
        body: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: dailyList?.length == 0
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                      itemCount: dailyList?.length,
                      itemBuilder: (context, index) {
                        return closure_card(dailyList![index]);
                      },
                    ),
                  )));
  }
}

closure_card(CourseDB info) {
  // if bla bla
  Color courseColor = HexColor(info.colorCode);
  return Container(
    padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 0),
    child: GestureDetector(
      onTap: () async {
        await DailyClosure().writeDataToFile(info);
        Communication().readCommunication().then((value){
          print(value);
        });
      },
      child: Card(
        color: Colors.red.withOpacity(0.5),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: courseColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        info.gName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Schüler: ${info.amountPupils}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Datum: ${DateFormat('dd.MM.yyyy').format(info.courseDate)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Beginn: ${info.startTime} Uhr",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          ampmSelector(info.amPm),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
