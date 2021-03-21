import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewMessage extends StatefulWidget {
  final Map map;
  NewMessage(this.map);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  bool isSharee;
  var _enteredMessage = '';
  final _controller = TextEditingController();
  var map;

  @override
  void initState() {
    super.initState();
    map = widget.map;
  }

  void sendMsg(Map map, String msg) async {
    _controller.clear();
    FocusScope.of(context).unfocus();
    try {
      List<dynamic> data = [];
      String cryptoResult = map["cryptoUsername"].toString();
      var m;
      FirebaseDatabase.instance
          .reference()
          .child("chats")
          .child(cryptoResult)
          .once()
          .then((val) {
        m = val.value;
        if (m["msgList"] != null)
          data = m["msgList"];
        else
          data = [];
      }).then((value) {
        log(data.toString());
        Map<dynamic, dynamic> msgMap = {
          "msg": msg,
          "sentBy": map["sentBy"].toString(),
          "isSharee": map["isSharee"],
        };
        List<dynamic> msgList = data.toList();
        msgList.insert(0, msgMap);
        final databaseReference = FirebaseDatabase.instance.reference();
        databaseReference
            .child("chats")
            .child(cryptoResult)
            .update({"msgList": msgList});
      });
    } catch (e) {
      log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@error' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message..'),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
            IconButton(
                icon: Icon(Icons.send, color: Colors.green),
                onPressed: () {
                  if (_enteredMessage.trim().isNotEmpty)
                    sendMsg(map, _enteredMessage);
                })
          ],
        ),
      ),
    );
  }
}
