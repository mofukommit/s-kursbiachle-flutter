import 'dart:ffi';

import 'package:flutter/material.dart';
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
  get result => null;
  

  @override
  void initState() {
    super.initState();
    check_if_registered()
        .then((result) {
          if (result == true){
            //fetch data from API
            gotData = true;
            getData();
          }
        }
    );
  }

  check_if_registered() async {
    late KeyDB key;
    try{
      key = await KeyDatabase.instance.readKey(1);
    }on Exception {
      return false;
    }
    if (key.costumerKey != ''){
      return true;
    }else{
      return false;
    }
  }

  getData() async {
    posts = await GetCourses().getPosts();
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future refresh() async {
    if(gotData == false){
      check_if_registered()
          .then((result) {
          if (result == true){
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

  checkWidget(){
    if(gotData){
      return isAuth();
    }else{
      return notAuth();
    }
  }

  Widget notAuth(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.kommit,
        title: const Text('Kursübersicht'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          physics:AlwaysScrollableScrollPhysics(),
          itemCount: 1,
          padding: const EdgeInsets.only(top: 50),
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 8,
                shadowColor: Colors.kommit,
                child: SizedBox(
                  height: 500,
                  child: Container(
                    padding: EdgeInsets.only(left:15, bottom: 50, right: 20, top:50),

                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left:0, bottom: 10, right: 0, top:0),
                          child: const Center(
                              child: Text(
                                  'Bitte Authorisieren Sie sich bei Ihrer Skischule.\n'
                                      'Nur so können Sie Ihre Daten einsehen und bearbeiten. \n\n'
                                      'Scannen Sie bei Ihrer Skischulverwaltung einfach Ihren persönlichen QR-Code ein!',
                                textAlign: TextAlign.center,
                                textScaleFactor: 2.0,
                              )
                          ),
                        ),
                        Container(
                          child: const Center(
                              child: Text(
                                'Nachdem Sie diesen eingescannt haben, können Sie diese Seite mit einem Wisch von oben nach unten aktualisieren',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ),
            );
          },
      )
      )
    );
  }

  Widget isAuth(){
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
        ? const Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
          itemCount: posts?.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/courseDetails',
                            arguments: {
                              'courseId': posts![index].courseId,
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts![index].gName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Beginn: ${posts![index].startTime} Uhr",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}
