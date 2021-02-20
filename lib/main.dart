import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_application_1/json.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JsonList(),
    );
  }
}

class JsonList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JsonListState();
}

class JsonListState extends State {
  Future<List<Others>> _getEarthquakes() async {
    var data = await http.get("https://deprem.afad.gov.tr/latestCatalogsList");
    var jsonData = json.decode(data.body);

    List<Others> earthquakes = [];

    for (var u in jsonData) {
      Others others = Others(u["city"]);

      earthquakes.add(others);
    }

    print(earthquakes.length);

    return earthquakes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AFAD Earthquake List"),
          centerTitle: true,
        ),
        body: Container(
            child: FutureBuilder(
          future: _getEarthquakes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Align(
                      alignment: Alignment(0.00, 0.50),
                      child: Text("Loading... Please Wait"),
                    )
                  ]);
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(color: Colors.red[300]),
                        child: ListTile(
                          title: Text(
                            "Country : " + snapshot.data[index].city,
                          ),
                        ));
                  });
            }
          },
        )));
  }
}
