import 'package:flutter/material.dart';
import 'package:skursbiachle/pages/settings/availability.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.kommit,
          title: const Text("Einstellungen"),
          centerTitle: true),
      body: settingsList(context),
    );
  }
  
  Widget settingsList(BuildContext context){

    return GridView.count(
      padding: EdgeInsets.all(10),
      crossAxisCount: 2,
      children: [
        Card(
          margin: EdgeInsets.all(10.0),
          color: Colors.kommit.shade100,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Colors.transparent
            ),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Availability()));
              },
              child: Column(
                children: [
                  Spacer(),
                  Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.kommit.shade300,
                      size: 50.0
                  ),
                  Text('Verfügbarkeit', style: TextStyle(color: Colors.kommit),),
                  Spacer()
                ],
              )
          )
        ),
        Card(
            margin: EdgeInsets.all(10.0),
            color: Colors.kommit.shade100,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: Colors.transparent
                ),
                onPressed: (){
                  print('PRESSED Personal');
                },
                child: Column(
                  children: [
                    Spacer(),
                    Icon(
                        Icons.person,
                        color: Colors.kommit.shade300,
                        size: 50.0
                    ),
                    Text('Personaldaten', style: TextStyle(color: Colors.kommit),),
                    Spacer()
                  ],
                )
            )
        ),
        Card(
            margin: EdgeInsets.all(10.0),
            color: Colors.kommit.shade100,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: Colors.transparent
                ),
                onPressed: (){
                  print('PRESSED Ausbildung');
                },
                child: Column(
                  children: [
                    Spacer(),
                    Icon(
                        Icons.history_edu,
                        color: Colors.kommit.shade300,
                        size: 50.0
                    ),
                    Text('Ausbildung', style: TextStyle(color: Colors.kommit),),
                    Spacer()
                  ],
                )
            )
        ),
        Card(
            margin: EdgeInsets.all(10.0),
            color: Colors.kommit.shade100,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: Colors.transparent
                ),
                onPressed: (){
                  print('PRESSED Stats');
                },
                child: Column(
                  children: [
                    Spacer(),
                    Icon(
                        Icons.query_stats,
                        color: Colors.kommit.shade300,
                        size: 50.0
                    ),
                    Text('Statistiken', style: TextStyle(color: Colors.kommit),),
                    Spacer()
                  ],
                )
            )
        ),
        Card(
            margin: EdgeInsets.all(10.0),
            color: Colors.kommit.shade100,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: Colors.transparent
                ),
                onPressed: (){
                  print('PRESSED Favorites');
                },
                child: Column(
                  children: [
                    Spacer(),
                    Icon(
                        Icons.favorite,
                        color: Colors.kommit.shade300,
                        size: 50.0
                    ),
                    Text('Favoriten', style: TextStyle(color: Colors.kommit),),
                    Spacer()
                  ],
                )
            )
        ),
      ],
    );
  }
}
