import 'package:aiko_bot/despex.dart';
import 'package:flutter/material.dart';
import 'package:aiko_bot/smart_reply.dart';
import 'package:aiko_bot/firebase_tests.dart';
import 'package:google_fonts/google_fonts.dart';

main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme:
              GoogleFonts.fondamentoTextTheme(Theme.of(context).textTheme),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Testes",
          style: TextStyle(
              color: Colors.white,
              fontSize: 30 * MediaQuery.of(context).textScaleFactor),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "App despesas",
                        textScaleFactor: 1.3,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Text(
                          "Ir",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.cyan,
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new DespexApp()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Firebase Analytics e Crashlytics",
                        textScaleFactor: 1.3,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Text(
                          "Ir",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.cyan,
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new FlutterFire()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Firebase Smart Reply ML",
                        textScaleFactor: 1.3,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Text(
                          "Ir",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.cyan,
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SmartChat()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
