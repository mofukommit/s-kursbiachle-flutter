import 'package:flutter/material.dart';
import 'package:skursbiachle/services/get_pupil_by_qr.dart';
import 'package:skursbiachle/services/json_pupil_qr.dart';

import '../../widgets/accordion.dart';

class PupilCheck extends StatefulWidget {
  final Map<String, dynamic>? args;

  const PupilCheck(this.args, {Key? key}) : super(key: key);

  static const routeName = '/PupilCheck';

  @override
  State<PupilCheck> createState() => PupilCheckState();
}

class PupilCheckState extends State<PupilCheck> {
  late Pupil? pupil;
  var isLoaded = false;

  // design var
  var rowAlignment = MainAxisAlignment.center;
  double rowPadding = 25;
  double rowPaddingRight = 50;
  double rowGap = 50;

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
          child: PageView.builder(
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 180,
                      child: Row(
                        children: [
                          // margin-left:
                          const SizedBox(width: 50, height: 100),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  // vertical align
                                  children: [
                                    const SizedBox(height: 20),
                                    Column(
                                      children: [
                                        Text(
                                          "${pupil!.fname} ${pupil!.sname}",
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              "Geburtstdatum:",
                                              style: TextStyle(),
                                            ),
                                            Text(
                                              "Präf. Lehrer:",
                                              style: TextStyle(),
                                            ),
                                          ],
                                        ),
                                        Column(children: [
                                          Text(
                                            pupil!.age.toString(),
                                            style: const TextStyle(),
                                          ),
                                          Text(
                                            pupil!.prefTeach.toString(),
                                            style: const TextStyle(),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ],
                                )),
                          ),

                          // margin-right:
                          const SizedBox(width: 50, height: 100),
                        ],
                      )),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Accordion(
                        title: 'Section #1',
                        content: pupil!.addr.toString()),
                      const Accordion(
                          title: 'Section #2',
                          content:
                              'Fusce ex mi, commodo ut bibendum sit amet, faucibus ac felis. Nullam vel accumsan turpis, quis pretium ipsum. Pellentesque tristique, diam at congue viverra, neque dolor suscipit justo, vitae elementum leo sem vel ipsum'),
                      const Accordion(
                          title: 'Section #3',
                          content:
                              'Nulla facilisi. Donec a bibendum metus. Fusce tristique ex lacus, ac finibus quam semper eu. Ut maximus, enim eu ornare fringilla, metus neque luctus est, rutrum accumsan nibh ipsum in erat. Morbi tristique accumsan odio quis luctus.'),
                    ],
                  ),
                  const SizedBox(height: 200),
                  Center(
                      child: WillPopScope(
                    onWillPop: () async {
                      Navigator.pop(context, true);
                      return true;
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.kommit,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Bestätigen'),
                    ),
                  )),
                ],
              );
            },
          )),
    );
  }
}
