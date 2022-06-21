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
    }catch (_) {
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
    }
    setState(() => posts?.clear());
    List<Courses>? new_courses = await GetCourses().getPosts();
    setState(() {
      posts = new_courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return checkWidget();
  }

  checkWidget(){
    if(gotData){
      return getWidget();
    }else{
      return getOtherWidget();
    }
  }

  Widget getOtherWidget(){
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
          itemBuilder: (BuildContext context, int index) {
            return const Center(
              child: Text(
                'Bitte Authentifizieren Sie sich bei Ihrer Skischule \n '
                    'Einfach den QR-Code abscannen, \n '
                    'welcher für Sie erstellt wurde',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black87,
                ),
              ),
            );
          },
      )
      )
    );
  }

  Widget getWidget(){
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
        child: posts!.isEmpty
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
