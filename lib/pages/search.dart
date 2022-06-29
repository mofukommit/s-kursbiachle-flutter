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
    posts = await GetPupils().getSearchResults(fname, sname);
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: fnameController,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                onFieldSubmitted: (value) {
                                  fname = fnameController.text;
                                  sname = snameController.text;
                                  isLoaded = false;
                                  isSearched = true;
                                  getPupils();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Vorname',
                                  labelStyle: const TextStyle(
                                    color: Colors.kommit,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF8098A3), width: 2.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                /* validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Bitte einen Namen eintragen';
                                }
                                return null;
                              }, */
                              )),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              controller: snameController,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value) {
                                fname = fnameController.text;
                                sname = snameController.text;
                                isLoaded = false;
                                isSearched = true;
                                getPupils();
                              },
                              decoration: InputDecoration(
                                labelText: 'Nachname',
                                labelStyle: const TextStyle(
                                  color: Colors.kommit,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8098A3), width: 2.0),
                                ),
                                border: const OutlineInputBorder(),
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
                          Flexible(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
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
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.kommit,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
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
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const Divider(
                  height: 2,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Expanded(
                  child: Visibility(
                    visible: isSearched,
                    child: Visibility(
                      visible: isLoaded,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView.separated(
                          itemCount: posts?.length ?? 0,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 2,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/pupilCheck',
                                      arguments: {
                                        'pupilID': posts![index].pupilId,
                                      });
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(0),
                                  elevation: 0,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10.0, top: 0, bottom: 0),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.kommit.withOpacity(0.1),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${index.abs() + 1}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      textLength(posts![index])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

Widget textLength(Pupilsearch posts){
  var fname = '';
  var sname = '';
  if (posts.fname.length > 8){
    fname = '${posts.fname.substring(0, 8)}...';
  }else{
    fname = posts.fname;
  }
  if (posts.sname.length > 8){
    sname = '${posts.sname.substring(0, 8)}...';
  }else{
    sname = posts.sname;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${fname} ${sname}",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      Text(
        "Alter: ${posts.age}",
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    ],
  );
}