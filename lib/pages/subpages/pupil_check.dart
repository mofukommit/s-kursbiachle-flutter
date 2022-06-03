import 'package:flutter/material.dart';
import 'package:skursbiachle/services/get_pupil.dart';
import 'package:skursbiachle/services/json_pupil.dart';

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
                children: [
                  SizedBox(height: 100),
                  SizedBox(
                      height: 180,
                      child: Row(
                        children: [
                          Container(width: 50, height: 100),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${pupil!.fname} ${pupil!.sname}",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Level: Anfänger",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Kurs: Zwergerl G2",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            width: 50,
                          )
                        ],
                      )),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.kommit,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Bestätigen'),
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}
