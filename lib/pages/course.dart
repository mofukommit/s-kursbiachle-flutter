import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/teacher_database.dart';
import '../model/teacher.dart';
import '../services/get_courses.dart';
import '../services/json_courses.dart';

class Course extends StatefulWidget {
  const Course({Key? key}) : super(key: key);

  @override
  CourseState createState() => CourseState();
}

class CourseState extends State<Course> {
  List<Courses>? posts;
  var isLoaded = false;
  var gotData = false;
  List<Widget> widgetList = [];
  List<String> dateList = [];
  get result => null;

  @override
  void initState() {
    super.initState();
    check_if_registered().then((result) {
      if (result == true) {
        //fetch data from API
        gotData = true;
        getData();
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

  getData() async {
    posts = await GetCourses().getPosts();
    if (posts != null) {
      dataIterator(posts!);
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future refresh() async {
    if (gotData == false) {
      check_if_registered().then((result) {
        if (result == true) {
          //fetch data from API
          gotData = true;
          getData();
        }
      });
    } else {
      setState(() => posts?.clear());
      List<Courses>? new_courses = await GetCourses().getPosts();
      setState(() {
        posts = new_courses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkWidget();
  }

  checkWidget() {
    if (gotData) {
      return isAuth();
    } else {
      return notAuth();
    }
  }

  dataIterator(List<Courses> courses) {
    for (var course in courses) {
      dateChecker(course);
    }
  }

  dateChecker(Courses course) {
    DateTime today = new DateTime.now();
    DateTime? c_date = course.courseDate;

    if (c_date.year == today.year &&
        c_date.month == today.month &&
        c_date.day == today.day) {
      if (!dateList.contains(DateFormat('dd-MM-yyyy').format(c_date))) {
        dateList.add(DateFormat('dd-MM-yyyy').format(c_date));
        widgetList.add(
          Container(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text('Heute - ${c_date.day}.${c_date.month}.${c_date.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
          ),
        );
        widgetList.add(
          dateContainer(context, course),
        );
      } else {
        widgetList.add(Column(
          children: [
            dateContainer(context, course),
          ],
        ));
      }
    } else {
      var tomorrow = DateTime(today.year, today.month, today.day + 1);
      if (!dateList.contains(DateFormat('dd-MM-yyyy').format(c_date))) {
        dateList.add(DateFormat('dd-MM-yyyy').format(c_date));
        if (c_date.year == tomorrow.year &&
            c_date.month == tomorrow.month &&
            c_date.day == tomorrow.day) {
          widgetList.add(
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child:
                  Text('Morgen - ${c_date.day}.${c_date.month}.${c_date.year}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
            ),
          );
          widgetList.add(
            dateContainer(context, course),
          );
        } else {
          widgetList.add(
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('${c_date.day}.${c_date.month}.${c_date.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
              ),
            ),
          );
          widgetList.add(
            dateContainer(context, course),
          );
        }
      } else {
        widgetList.add(
          dateContainer(context, course),
        );
      }
    }
  }

  Widget notAuth() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.kommit,
          title: const Text('Kursübersicht'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: 1,
              padding: const EdgeInsets.only(top: 20),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Card(
                    margin: const EdgeInsets.all(20),
                    elevation: 8,
                    shadowColor: Colors.kommit,
                    child: SizedBox(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 30, right: 20, top: 30),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 0, bottom: 10, right: 0, top: 0),
                              child: const Center(
                                  child: Text(
                                'Bitte Authorisieren Sie sich bei Ihrer Skischule.\n'
                                'Nur so können Sie Ihre Daten einsehen und bearbeiten. \n\n'
                                'Scannen Sie bei Ihrer Skischulverwaltung einfach Ihren persönlichen QR-Code ein!',
                                textAlign: TextAlign.center,
                                textScaleFactor: 2.0,
                              )),
                            ),
                            const Center(
                                child: Text(
                              'Nachdem Sie diesen eingescannt haben, können Sie diese Seite mit einem Wisch von oben nach unten aktualisieren',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )));
  }

  Widget isAuth() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.kommit,
        title: const Text('Kursübersicht'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: posts?.length == 0
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  itemCount: widgetList.length,
                  itemBuilder: (context, index) {
                    return widgetList[index];
                  },
                ),
              ),
      ),
    );
  }
}

Widget dateContainer(context, Courses course) {
  return Container(
    padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 0),
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/courseDetails', arguments: {
          'courseId': course.courseId,
          'courseDate': DateFormat('yyyy-MM-dd').format(course.courseDate),
        });
      },
      child: Card(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        course.gName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Anzahl: ${course.amountPupils}",
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
                          "Datum: ${DateFormat('dd.MM.yyyy').format(course.courseDate)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Beginn: ${course.startTime} Uhr    ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
