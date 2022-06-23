import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/get_course_details.dart';

class CourseDetails extends StatefulWidget {
  final Map<String, dynamic>? args;

  const CourseDetails(this.args, {Key? key}) : super(key: key);

  static const routeName = '/courseDetails';

  @override
  State<CourseDetails> createState() => CourseDetailsState();
}

class CourseDetailsState extends State<CourseDetails> {
  var isLoaded = false;
  var details;
  Color? colorCode;

  @override
  void initState() {
    super.initState();
    colorCode = widget.args!['color_code'];
    //fetch data from API
    getCourseDetails();
  }

  getCourseDetails() async {
    details = await GetCourseDetails().getDetails(widget.args!['courseId'], widget.args!['courseDate']);
    if (details != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.kommit,
          title:
          Row(
            children: [
              const Text(
                'Kursdetails',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  "Schüler: ${widget.args!['amount_pupils']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Visibility(
          visible: isLoaded,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: details?.length,
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
                        color: colorCode,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pupilDetail',
                              arguments: {
                                'pupilID': details[index].pupilId,
                              });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details[index].fname + ' ' + details[index].sname,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Von ${DateFormat('dd.MM.yyyy').format(details[index].startDate)} bis ${DateFormat('dd.MM.yyyy').format(details[index].endDate)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
