import 'package:flutter/material.dart';
import 'package:skursbiachle/services/get_pupil_by_qr.dart';
import 'package:skursbiachle/services/json_pupil_qr.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../services/post_pupil_to_my_course.dart';

class PupilCheck extends StatefulWidget {
  final Map<String, dynamic>? args;

  const PupilCheck(this.args, {Key? key}) : super(key: key);

  static const routeName = '/PupilCheck';

  @override
  State<PupilCheck> createState() => PupilCheckState();
}

class PupilCheckState extends State<PupilCheck> {
  var isLoaded = false;
  Pupil? pupil;

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getPupil();
  }

  getPupil() async {
    pupil = await GetPupil().getPupil(widget.args!['pupilID']);
    if (pupil != null) {
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
          title: const Text("Schüler"),
          centerTitle: true,
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "${pupil!.fname} ${pupil!.sname}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Alter: ${pupil!.age}",
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Präferenz: ${pupil!.prefTeach}",
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          FlutterPhoneDirectCaller.callNumber(
                              pupil!.tel.toString());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.kommit,
                        ),
                        icon: Text(
                          "Tel.: ${pupil!.tel}",
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        label: const Icon(Icons.phone, size: 24.0),
                      ),
                      const SizedBox(height: 20),
                      ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Accordion(
                              disableScrolling: true,
                              maxOpenSections: 2,
                              headerBackgroundColor: Colors.kommit,
                              contentBorderColor: Colors.kommit,
                              // leftIcon: const Icon(Icons.audiotrack, color: Colors.white),
                              children: [
                                AccordionSection(
                                  isOpen: false,
                                  header: const Text('Bisherige Kurse',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  content: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: pupil?.courses.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            pupil!.courses[index].courseId
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                AccordionSection(
                                  isOpen: false,
                                  header: const Text('Adresse/n',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  content: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: pupil?.addr.length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        "${pupil!.addr[index].reFname} ${pupil!.addr[index].reSname} \n${pupil!.addr[index].street} ${pupil!.addr[index].housenr}\n${pupil!.addr[index].plz} ${pupil!.addr[index].city} \n${pupil!.addr[index].country}",
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            WillPopScope(
                              onWillPop: () async {
                                Navigator.pop(context, true);
                                return true;
                              },
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  isLoaded = false;
                                },
                                child: const Text('Abbrechen',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
                              onPressed: () {
                                PostNewPupilActiveCourse().postPupil(pupil?.pId).then((re) {
                                  if (re){
                                    Navigator.pop(context, true);
                                  } else {
                                    print('FEHLER!!');
                                  }
                                });
                              },
                              child: const Text('In Gruppe übertragen',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })));
  }
}