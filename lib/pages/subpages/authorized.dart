import 'package:flutter/material.dart';
import 'package:skursbiachle/services/authorization.dart';
import 'package:skursbiachle/services/get_pupil_by_qr.dart';
import 'package:skursbiachle/services/json_pupil_qr.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Authorized extends StatefulWidget {
  const Authorized({Key? key}) : super(key: key);

  static const routeName = '/authorized';

  @override
  State<Authorized> createState() => AuthorizedState();
}

class AuthorizedState extends State<Authorized> {
  var isLoaded = false;
  Teacher? res;

  @override
  void initState() {
    super.initState();
    //fetch data from API
    checkAuth();
  }

  checkAuth() async {
    res = await GetAuth().checkAuthorization();
    if (res != null) {
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
          title: const Text("Authorisierung"),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Text('${res?.fname} ${res?.sname}'),
        ),
    );
  }
}
