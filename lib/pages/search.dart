import 'package:flutter/material.dart';

import '../services/get_pupil_by_name.dart';
import '../services/json_pupil_name.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  List<Pupilsearch>? posts;

  final _formKey = GlobalKey<FormState>();

  var fname = "none";
  var sname = "none";

  TextEditingController fnameController = TextEditingController(text: "");
  TextEditingController snameController = TextEditingController(text: "");

  var isLoaded = false;
  var isSearched = false;

  @override
  void initState() {
    super.initState();
  }

  getPupils() async {
    posts = await GetPupils().getPosts(fname, sname);
    if (posts != null) {
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
          title: const Text('Schülersuche'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: TextFormField(
                        controller: fnameController,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Vorname',
                          border: OutlineInputBorder(),
                        ),
                        /* validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Bitte einen Namen eintragen';
                                  }
                                  return null;
                                }, */
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: snameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Nachname',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: const TextStyle(color: Colors.white)),
                        onPressed: () {
                          // reset() setzt alle Felder wieder auf den Initialwert zurück
                          _formKey.currentState!.reset();
                          // Löscht Inputfelder
                          fnameController.text = "";
                          snameController.text = "";
                          // Löscht beschriebene Parameter
                          fname = "";
                          sname = "";
                          // Löscht bereits gelistete Schüler
                          getPupils();
                        },
                        child: const Text('Löschen'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.kommit,
                            textStyle: const TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Todo Validation für Inputfelder hinzufügen
                          if (_formKey.currentState!.validate()) {
                            fname = fnameController.text;
                            sname = snameController.text;
                            isLoaded = false;
                            isSearched = true;
                            getPupils();
                            print(
                                "Formular ist gültig und kann verarbeitet werden");
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: const Text('Suchen'),
                      )
                    ],
                  ),
                  const SizedBox(height: 29),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height * 0.5,
                    // Ladebildschirm wird erst angezeigt,
                    // wenn auch zu suchen angefangen wurde
                    child: Visibility(
                      visible: isSearched,
                      child: Visibility(
                        visible: isLoaded,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ListView.builder(
                          itemCount: posts?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/pupilCheck',
                                    arguments: {
                                      'pupilID': posts![index].pupilId,
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${index.abs() + 1}. ${posts![index].fname} ${posts![index].sname}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
