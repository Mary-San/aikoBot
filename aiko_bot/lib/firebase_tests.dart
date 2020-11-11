import 'dart:io';
// import 'dart:math';
import 'dart:async';
import 'package:aiko_bot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:aiko_bot/componentes/chart.dart';
// import 'package:aiko_bot/models/transaction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:aiko_bot/componentes/Transaction_form.dart';
// import 'package:aiko_bot/componentes/transaction_List.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_fonts/google_fonts.dart';

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(DespexApp());
}
*/

final _kShouldTestAsyncErrorOnInit = false;

final _kTestingCrashlytics = true;

// ignore: public_member_api_docs
class FlutterFire extends StatefulWidget {
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseAnalytics().logEvent(name: "main_page");
  }

  @override
  _FlutterFireState createState() => _FlutterFireState();
}

class _FlutterFireState extends State<FlutterFire> {
  Future<void> _initializeFlutterFireFuture;

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(
      const Duration(seconds: 2),
      () {
        final List<int> list = <int>[];
        print(list[100]);
      },
    );
  }

  Future<void> _initializeFlutterFire() async {
    await Firebase.initializeApp();

    if (_kTestingCrashlytics) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      originalOnError(errorDetails);
    };

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: GoogleFonts.fondamentoTextTheme(Theme.of(context).textTheme),
        ),
        primarySwatch: Colors.cyan,
        accentColor: Colors.cyan[900],
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new MainPage(),
                ),
              );
            },
          ),
          title: Text(
            "Firebase App",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30 * MediaQuery.of(context).textScaleFactor),
          ),
        ),
        body: FutureBuilder(
          future: _initializeFlutterFireFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return Center(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          FirebaseCrashlytics.instance.log('Ok');
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Everything is ok!'),
                              duration: Duration(seconds: 10),
                            ),
                          );
                        },
                      ),
                      RaisedButton(
                        child: const Text('Key'),
                        onPressed: () {
                          FirebaseCrashlytics.instance
                              .setCustomKey('example', 'flutterfire');
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Custom Key "example: flutterfire" has been set \n'
                                  'Key will appear in Firebase Console once app has crashed and reopened'),
                              duration: Duration(seconds: 10),
                            ),
                          );
                        },
                      ),
                      RaisedButton(
                        child: const Text('Log'),
                        onPressed: () {
                          FirebaseCrashlytics.instance
                              .log('This is a log example');
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'The message "This is a log example" has been logged \n'
                                  'Message will appear in Firebase Console once app has crashed and reopened'),
                              duration: Duration(seconds: 10),
                            ),
                          );
                        },
                      ),
                      RaisedButton(
                        child: const Text('Crash'),
                        onPressed: () async {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('App will crash is 5 seconds \n'
                                  'Please reopen to send data to Crashlytics'),
                              duration: Duration(seconds: 10),
                            ),
                          );

                          sleep(
                            const Duration(seconds: 10),
                          );

                          FirebaseCrashlytics.instance.crash();
                        },
                      ),
                      RaisedButton(
                        child: const Text('Throw Error'),
                        onPressed: () {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Thrown error has been caught \n'
                                  'Please crash and reopen to send data to Crashlytics'),
                              duration: Duration(seconds: 10),
                            ),
                          );

                          throw StateError('Uncaught error thrown by app');
                        },
                      ),
                      RaisedButton(
                        child: const Text('Record Error'),
                        onPressed: () async {
                          try {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Recorded Error  \n'
                                    'Please crash and reopen to send data to Crashlytics'),
                                duration: Duration(seconds: 10),
                              ),
                            );
                            throw 'error_example';
                          } catch (e, s) {
                            await FirebaseCrashlytics.instance
                                .recordError(e, s, reason: 'as an example');
                          }
                        },
                      ),
                      RaisedButton(
                        child: const Text('Async out of bounds'),
                        onPressed: () {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Uncaught Exception that is handled by second parameter of runZonedGuarded \n'
                                  'Please crash and reopen to send data to Crashlytics'),
                              duration: Duration(seconds: 10),
                            ),
                          );

                          runZonedGuarded(() {
                            Future<void>.delayed(
                              const Duration(seconds: 2),
                              () {
                                final List<int> list = <int>[];
                                print(list[100]);
                              },
                            );
                          }, FirebaseCrashlytics.instance.recordError);
                        },
                      ),
                    ],
                  ),
                );
                break;
              default:
                return Center(
                  child: Text('Loading'),
                );
            }
          },
        ),
      ),
    );
  }
}
