import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();

  //Dropdownmenü
  String selectedValue = "Kurs";
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Kurs", child: Text("Kurs")),
      const DropdownMenuItem(value: "Zwergel-K", child: Text("Zwergel-K")),
      const DropdownMenuItem(value: "Zwergerl-G1", child: Text("Zwergerl-G1")),
      const DropdownMenuItem(value: "Zwergerl-G2-F", child: Text("Zwergerl-G2-F")),
    ];
    return menuItems;
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
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  labelText: 'Vorname',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Bitte einen Namen eintragen';
                                  }
                                  return null;
                                },
                              )
                            ],
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: const TextStyle(color: Colors.white)),
                        onPressed: () {
                          // reset() setzt alle Felder wieder auf den Initialwert zurück
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Löschen'),
                      ),
                      const SizedBox(width: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.kommit,
                            textStyle: const TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          // Todo: Min 1 Validator = true, aber egal welcher
                          if (_formKey.currentState!.validate()) {
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
                  // Todo: Visibility & isLoaded für Suchergebnisse verwenden
                  Container(
                    color: Colors.blueGrey,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: const Text("Hier wird das Ergebnis gelistet. Contenthintergrund vorläufig farbig zur Visualisierung des Platzbedarfs."),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}