import 'package:flutter/material.dart';

import '../services/get_pupil_by_name.dart';
import '../services/json_pupil_name.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();

  var fname = "none";
  var sname = "none";

  TextEditingController fnameController = TextEditingController(text: "");
  TextEditingController snameController = TextEditingController(text: "");

  List<Pupilsearch>? posts;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    //fetch data from API

  }

  getPupils() async {
    posts = await GetPupils().getPosts(fname, sname);
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  /*
  //Dropdownmenü
  String selectedValue = "Kurs";
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      // Korrekte Namen verwenden
      const DropdownMenuItem(value: "Kurs", child: Text("Kurs")),
      const DropdownMenuItem(value: "Zwergel-K", child: Text("Zwergel-K")),
      const DropdownMenuItem(value: "Zwergerl-G1", child: Text("Zwergerl-G1")),
      const DropdownMenuItem(value: "Zwergerl-G2-F", child: Text("Zwergerl-G2-F")),
    ];
    return menuItems;
  }
  */

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
                      const SizedBox(width: 10,),
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
                  /*
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Kurs',
                      border: OutlineInputBorder(),
                    ),
                    disabledHint: const Text("Keine Auswahl möglich"),
                    value: selectedValue,
                    onChanged: (String? newValue){
                      setState(() {
                          selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems,
                  ),
                  const SizedBox(height: 20),
                  */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: const TextStyle(color: Colors.white)),
                        onPressed: () {
                          // reset() setzt alle Felder wieder auf den Initialwert zurück
                          // Todo: Fehler - Listenansicht wird beim Löschen nicht ebenfalls entfernt
                          _formKey.currentState!.reset();
                          fnameController.text = "";
                          snameController.text = "";
                          GetPupils();
                        },
                        child: const Text('Löschen'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.kommit,
                            textStyle: const TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            fname = fnameController.text;
                            sname = snameController.text;
                            getPupils();
                            print("Formular ist gültig und kann verarbeitet werden");
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
                    child: Visibility(
                      visible: isLoaded,
                      // Todo: Fehler - Ladescreen wird angezeigt, noch bevor Suche eingegeben wurde
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ListView.builder(
                        itemCount: posts?.length,
                        itemBuilder: (context, index) {
                          return Container(
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
                                        "${index.abs()+1}. ${posts![index].fname} ${posts![index].sname}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(height: 5,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
