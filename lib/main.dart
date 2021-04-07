import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simpsons/Quote.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simpson Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Quote> futureQuote;

  @override
  void initState() {
    super.initState();
    futureQuote = getQuote();
  }

  Future<Quote> getQuote() async {
    final response = await http
        .get(Uri.parse('https://thesimpsonsquoteapi.glitch.me/quotes'));
    var responseBody = response.body;
    if (response.statusCode == 200) {
      return Quote.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to load quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Quote>(
          future: futureQuote,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Text(
                        snapshot.data.character,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Image.network(snapshot.data.image.toString()),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Text(
                        "\"${snapshot.data.quote}\"",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator(
              color: Colors.black12,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                futureQuote = getQuote();
              });
            },
            child: Icon(Icons.refresh)));
  }
}
