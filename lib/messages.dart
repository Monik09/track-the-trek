import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_me_beacon/msg_bubble.dart';
import 'package:firebase_database/firebase_database.dart';

class Messages extends StatefulWidget {
  final Map mapu;
  Messages(this.mapu);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Map<dynamic, dynamic> map = {};
  List<String> list = [];
  Map mapu = {};
  List<dynamic> lu = [];

  @override
  void initState() {
    super.initState();
    mapu = widget.mapu;
    FirebaseDatabase.instance
        .reference()
        .child("chats")
        .child(mapu["cryptoUsername"])
        .onValue
        .listen(
      (event) {
        try {
          map = event.snapshot.value as Map<dynamic, dynamic>;
          lu = (map["msgList"] != null) ? map["msgList"] : [];
        } catch (e) {
          log("Eroror========================================" + e.toString());
         }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child("chats")
          .child(mapu["cryptoUsername"])
          .onValue,
      builder: (ctx, chatSnapshot) {
        log(chatSnapshot.data.toString());
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) {
            if (lu.isNotEmpty)
              return MessageBubble(
                lu[index],
              );
            return CircularProgressIndicator();
          },
          itemCount: lu.length,
        );
      },
    );
  }
}
