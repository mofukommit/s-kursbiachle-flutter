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
  Future<Pupil>? futurePupil;

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getPupil();
  }

  getPupil() async {
    var futurePupil = await GetPupil().getPupil(widget.args!['pupilID']);
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
      body: Center(
        child: Text(widget.args!['pupilID']),

        /* child: FutureBuilder<Pupil>(
          future: futurePupil,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.pId);
            }else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ), */

      ),
    );
  }
}
