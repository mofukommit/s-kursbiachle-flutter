import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skursbiachle/services/get_pupil_by_qr.dart';
import 'package:skursbiachle/services/json_pupil_qr.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../services/post_pupil_to_my_course.dart';
import '../../extensions/accord.dart';

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


  showTeacher(var msg) {
    if(msg != null) {
      return Text("Präferierter Lehrer: ${pupil!.prefTeach}\n",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ));
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
              return
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 4,
                            shadowColor: Colors.kommit,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
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

                                  Column(
                                    children: [
                                      if(pupil!.prefTeach != null)...[
                                        const SizedBox(height: 20),
                                        Text("Präferierter Lehrer: ${pupil!.prefTeach}\n",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            height: 1.5,
                                          ),)
                                      ]
                                    ],
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
                                ],
                              ),
                            ),
                          ),
                          Accordione(
                            title: 'Bisherige Kurse',
                            content: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: pupil?.courses.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Text(
                                      "Datum: ${DateFormat('dd.MM.yyyy').format(pupil!.courses[index].startDate)}\n"
                                      "Dauer: ${pupil!.courses[index].courseDays} Tage\n",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                      ),
                                    ),
                                    if(pupil!.courses[index].privHours != null)...[
                                      Text("Privatstunden: ${pupil!.courses[index].privHours}\n",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                      ),)
                                    ]
                                  ],
                                );
                              },
                            ),
                          ),
                          Accordione(
                            title: 'Adresse',
                            content: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: pupil?.addr.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${pupil!.addr[index].reFname} ${pupil!.addr[index].reSname}\n"
                                      "${pupil!.addr[index].street} ${pupil!.addr[index].housenr}\n"
                                      "${pupil!.addr[index].plz} ${pupil!.addr[index].city}\n"
                                      "${pupil!.addr[index].country}",
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: WillPopScope(
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
                                        child: const Center(
                                          child: Text('Abbrechen',
                                              softWrap: false,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          textStyle: const TextStyle(
                                              color: Colors.white)),
                                      onPressed: () {
                                        PostNewPupilActiveCourse()
                                            .postPupil(pupil?.pId)
                                            .then((re) {
                                          if (re) {
                                            Navigator.pop(context, true);
                                          } else {
                                            print('FEHLER!!');
                                          }
                                        });
                                      },
                                      child: const Text('Zuweisen',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )));
            })));
  }
}
