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
    // Extract the arguments from the current ModalRoute
    // final String pupilID = ModalRoute.of(context)!.settings.arguments as String;
    // print(GetPupil().getPupil(pupilID));
    // print(this.futurePupil);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.kommit,
        title: const Text("Testseite"),
        centerTitle: true,
      ),
      body: Visibility(
          visible: isLoaded,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: PageView.builder(
            itemBuilder: (context, index) {
              return Container(
                child: Text(pupil!.sname),
              );
            },
          )),
    );
  }
}
