import 'package:flutter/material.dart';
import 'package:aiko_bot/Despex/models/transaction.dart';
import 'package:aiko_bot/Despex/componentes/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transacao;
  final void Function(String) remove;

  TransactionList(this.transacao, this.remove){
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    return transacao.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    "There's nothing here? Ok... I will sleep!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.cyan, fontSize: 23),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'lib/images/koala2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transacao.length,
            itemBuilder: (ctx, index) {
              final tr = transacao[index];
              return TransactionItem(tr: tr, remove: remove);
            },
          );
  }
}