import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aiko_bot/Despex/models/transaction.dart';

class TransactionItem extends StatelessWidget {

  final Transaction tr;
  final void Function(String) remove;

  const TransactionItem({
    Key key,
    @required this.tr,
    @required this.remove,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text(
              'R\$${tr.value}',
            )),
          ),
        ),
        title: Text(
          tr.title,
          style: TextStyle(fontSize: 20, color: Colors.cyan[900]),
        ),
        subtitle: Text(
            DateFormat('EEEEE  d / MM / y').format(tr.date),
            style:
                TextStyle(fontSize: 15, color: Colors.cyan[300])),
        trailing: MediaQuery.of(context).size.width > 480
            ? FlatButton.icon(
                onPressed: () => remove(tr.id),
                icon: Icon(Icons.delete, color: Colors.cyan[300]),
                label: Text(
                  'Delete',
                  style: TextStyle(color: Colors.cyan[300]),
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Colors.cyan[300],
                onPressed: () => remove(tr.id),
              ),
      ),
    );
  }
}