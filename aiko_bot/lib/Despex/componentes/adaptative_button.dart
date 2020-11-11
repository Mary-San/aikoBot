import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  AdaptativeButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: null,
            onPressed: null,
            color: Colors.cyan[700],
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
          )
        : RaisedButton(
            color: Colors.cyan[700],
            textColor: Colors.white,
            child: Text(label, style: TextStyle(fontSize: 20)),
            onPressed: onPressed,
          );
  }
}
