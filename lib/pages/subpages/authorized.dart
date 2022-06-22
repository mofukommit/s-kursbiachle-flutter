import 'package:flutter/material.dart';
import 'package:skursbiachle/services/authorization.dart';

import '../../database/teacher_database.dart';
import '../../model/teacher.dart';

class Authorized extends StatefulWidget {
  final Map<String, dynamic>? args;

  const Authorized(this.args, {Key? key}) : super(key: key);

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

  Future writeKeys(costumerKey, costumerSec, url) async {
    print(costumerKey);
    print(costumerSec);
    print(url);

    final key = KeyDB(
        id: 1,
        costumerKey: costumerKey,
        costumerSec: costumerSec,
        url: url
    );
    await KeyDatabase.instance.create(key);
    return true;
  }

  checkAuth() async {
    writeKeys(widget.args!['customerkey'], widget.args!['customersecret'], widget.args!['url']).then((re) async {
      if (re){
        res = await GetAuth().checkAuthorization();
        if (res != null) {
          setState(() {
            isLoaded = true;
          });
        }
      }
    });

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
