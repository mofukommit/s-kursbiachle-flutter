import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skursbiachle/services/get_pupil.dart';
import 'package:skursbiachle/services/json_pupil.dart';

class PupilCheck extends StatefulWidget {
  PupilCheck({required this.pupilID, Key? key}) : super(key: key);
  String pupilID;

  static const routeName = '/PupilCheck';

  @override
  State<PupilCheck> createState() => _PupilCheckState();
}

class _PupilCheckState extends State<PupilCheck> {
  late Future<Pupil> futurePupil;

  String? pupilID;

  @override
  void initState() {
    super.initState();
    futurePupil = GetPupil().getPupil(pupilID);
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    this.pupilID = ModalRoute.of(context)!.settings.arguments as String;

    // print(GetPupil().getPupil(pupilID));
    print(this.futurePupil);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.kommit,
        title: const Text("Testseite"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<Pupil>(
          future: futurePupil,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.sname);
            }else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
