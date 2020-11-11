import 'chart_bar.dart'; 
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aiko_bot/Despex/models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransac;
  Chart(this.recentTransac);

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final wekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totSum = 0.0;

      for (var i = 0; i < recentTransac.length; i++) {
        bool sameDay = recentTransac[i].date.day == wekDay.day;
        bool sameMonth = recentTransac[i].date.month == wekDay.month;
        bool sameYear = recentTransac[i].date.year == wekDay.year;
        if (sameDay && sameMonth && sameYear) {
          totSum += recentTransac[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(wekDay)[0],
        'value': totSum,
      };
    }).reversed.toList();
  }

double get _wekTotalV{
  return groupedTransaction.fold(0.0 , (sum, tr){
    return sum + tr['value'] ;
  });
}

  @override
  Widget build(BuildContext context) {
    return 
     Container(
       height: MediaQuery.of(context).size.height * 0.4 ,
       child: Card(
        elevation: 5,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransaction.map((tr) {
              return 
              Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                  label: tr['day'],
                  value: tr['value'],
                  percent: _wekTotalV == 0 ? 0 : (tr['value'] as double) / _wekTotalV ,
                ),
              );
            }).toList(),
          ),
        ),
    ),
     );
  }
}
