import 'dart:io';
import 'dart:math';
import 'package:aiko_bot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aiko_bot/Despex/componentes/chart.dart';
import 'package:aiko_bot/Despex/models/transaction.dart';
import 'package:aiko_bot/Despex/componentes/transaction_List.dart';
import 'package:aiko_bot/Despex/componentes/Transaction_form.dart';

class DespexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  // ignore: deprecated_member_use
                  title: TextStyle(fontSize: 25, color: Colors.white),
                ),
          ),
          primarySwatch: Colors.cyan,
          accentColor: Colors.cyan[900],
          // ignore: deprecated_member_use
          primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
          textTheme:
              GoogleFonts.fondamentoTextTheme(Theme.of(context).textTheme)),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransac {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _deleteTrans(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTFM(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(
              icon,
              color: Colors.white,
            ))
        : IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscap =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.insert_chart;

    final actions = <Widget>[
      if (isLandscap)
        _getIconButton(
          _showChart ? iconList : iconChart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTFM(context),
      )
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('My Expenses'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
          )
        : AppBar(
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
            title: Text("My Expenses",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30 * MediaQuery.of(context).textScaleFactor)),
            textTheme: Theme.of(context).textTheme,
            actions: actions,
          );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodpage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_showChart || !isLandscap)
              Container(
                  height: availableHeight * (isLandscap ? 0.8 : 0.3),
                  child: Chart(_recentTransac)),
            if (!_showChart || !isLandscap)
              Container(
                height: availableHeight * (isLandscap ? 1 : 0.7),
                child: TransactionList(_transactions, _deleteTrans),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodpage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodpage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.cyan,
                    onPressed: () => _openTFM(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}