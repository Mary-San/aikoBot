import 'dart:async';
import 'package:aiko_bot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_reply/flutter_smart_reply.dart';
import 'package:google_fonts/google_fonts.dart';

class SmartChat extends StatefulWidget {
  @override
  _SmartChatState createState() => _SmartChatState();
}

class _SmartChatState extends State<SmartChat> {
  List<TextMessage> _textMessages = [];

  final myController = TextEditingController();

  List<String> _replies = List.empty();

  bool isSelfMode = true;

  Future<void> updateSmartReplies() async {
    try {
      _replies = await FlutterSmartReply.getSmartReplies(_textMessages);
    } on PlatformException {}
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
            "Smart Reply",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30 * MediaQuery.of(context).textScaleFactor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: _textMessages.reversed.map(_buildMessageItem).toList(),
              )),
              _buildSmartReplyRow(),
              Divider(color: Colors.blueGrey),
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(TextMessage message) => Container(
        height: 70,
        alignment: message.isSelf ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.all(5.0),
        child: Text(message.text),
      );

  Widget _buildSmartReplyRow() {
    return Container(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isSelfMode ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSelfMode) IconButton(
            icon: Icon(Icons.cloud),
            onPressed: () => setState(() => isSelfMode = !isSelfMode),
          ),
          _buildSmartReplyChips(),
          if (isSelfMode) IconButton(
            icon: Icon(Icons.home),
            onPressed: () => setState(() => isSelfMode = !isSelfMode),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartReplyChips() => ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: _replies.map(_buildSmartReplyChip).toList(),
      );

  Widget _buildSmartReplyChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _addMessage(text),
    );
  }

  Widget _buildInputField() {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration.collapsed(
                  hintText: isSelfMode ? 'send message as local side' : 'send message as remote side',
                ),
                onSubmitted: (message) => _addMessage(message),
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.send), onPressed: () => _addMessage(myController.text)),
        ],
      ),
    );
  }

  Future<void> _addMessage(String message) async {
    myController.clear();

    _textMessages.add(isSelfMode
        ? TextMessage.createForLocalUser(message, DateTime.now().millisecondsSinceEpoch)
        : TextMessage.createForRemoteUser(message, DateTime.now().millisecondsSinceEpoch));

    await updateSmartReplies();

    if (!mounted) return;

    isSelfMode = !isSelfMode;

    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}