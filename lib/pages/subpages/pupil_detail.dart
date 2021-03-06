import 'package:flutter/material.dart';
import 'package:skursbiachle/services/get_pupil_by_qr.dart';
import 'package:skursbiachle/services/json_pupil_qr.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../services/post_pupil_to_my_course.dart';
import '../../extensions/accord.dart';

class PupilDetail extends StatefulWidget {
  final Map<String, dynamic>? args;

  const PupilDetail(this.args, {Key? key}) : super(key: key);

  static const routeName = '/PupilDetail';

  @override
  State<PupilDetail> createState() => PupilDetailState();
}

class PupilDetailState extends State<PupilDetail> {
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
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
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
                                        const SizedBox(height: 20),
                                        Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "Präferenz: \nLehrer Sowieso${pupil!.prefTeach}",
                                            style: const TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.normal,
                                            ),
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
                                      return FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          pupil!.courses[index].courseId.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
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
                                            "578993 ${pupil!.addr[index].city}\n"
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
                              ],
                            ))),);
                })));
  }
}
