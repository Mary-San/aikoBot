import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aiko_bot/Despex/componentes/adaptative_button.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  DatePicker({this.selectedDate, this.onDateChanged});

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2019),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChanged,
            ),
          )
        : Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Date isn\'t found'
                        : 'Selected Date: \n ${DateFormat('EEEEE \n d / M / y').format(selectedDate)}',
                    style: TextStyle(color: Colors.cyan[700], fontSize: 20),
                  ),
                ),
                AdaptativeButton(
                    label: 'Select new Date', 
                    onPressed: () => _showDatePicker(context)),
              ],
            ),
          );
  }
}
