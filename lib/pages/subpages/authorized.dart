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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.only(
                  top: 50, left: 30, right: 30, bottom: 0),
              elevation: 8,
              shadowColor: Colors.kommit,
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Center(
                    child: Text(
                  'Angemeldet: \n\n ${res?.fname} ${res?.sname}',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.3,
                )),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    primary: Colors.green,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    )),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
