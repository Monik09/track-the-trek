import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:share/share.dart';
import 'package:track_me_beacon/map_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:track_me_beacon/messages.dart';
import 'package:track_me_beacon/new_messages.dart';

class ShowMapScreen extends StatefulWidget {
  static final String routeName = "/showMapScreen";
  @override
  _ShowMapScreenState createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  static int start = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.reference();
  void submitUserData(Map args) async {
    start = 1;
    String cryptoResult = args["cryptoUsername"], userName = args["userName"];

    FirebaseDatabase.instance
        .reference()
        .child("chats")
        .child(cryptoResult)
        .set({
      "hostName": userName,
      "isSharee": true,
      "cryptoUsername": cryptoResult,
      "msgList": [],
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args["isSharee"] && start == 0) submitUserData(args);

    if (!args["isSharee"])
      ref.child("locData").once().then(
        (snapshot) {
          log(snapshot.value[args["cryptoUsername"]].toString());
          print(snapshot.value[args["cryptoUsername"]].toString() ?? true);
          if (snapshot.value[args["cryptoUsername"]] == null) {
            log("in");
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  title: Text(
                    "No user found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).maybePop();
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      );

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.people_alt_outlined),
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            context: _scaffoldKey.currentContext,
            builder: (context) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Messages(
                        {
                          "sentBy": args["userName"],
                          "isSharee": args['isSharee'],
                          "cryptoUsername": args["cryptoUsername"],
                          "msgList": [],
                        },
                      ),
                    ),
                    NewMessage(
                      {
                        "sentBy": args["userName"],
                        "isSharee": args['isSharee'],
                        "cryptoUsername": args["cryptoUsername"],
                        "msgList": [],
                      },
                    ),
                  ],
                ),
              ); // ChatScreen(args["isSharee"]);
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: CircularNotchedRectangle(),
        child: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Colors.white, primaryColor: Colors.grey),
          child: BottomNavigationBar(
            onTap: (index) {
              if (index == 0) {
                ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
                  SnackBar(
                    content:
                        Text("Passkey Copied", textAlign: TextAlign.center),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.black87,
                    width: 150,
                  ),
                );
                FlutterClipboard.copy(args["cryptoUsername"])
                    .then((value) => print('copied'));
              } else {
                Share.share(
                    'Look, where I am. I am sharing my location with a passkey as:' +
                        args["cryptoUsername"]);
              }
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.copy_sharp,
                  color: Colors.grey[800],
                ),
                label: "Copy Passkey",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.share_sharp,
                  color: Colors.grey[800],
                ),
                label: "Share Passkey",
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              minimum: EdgeInsets.only(
                left: 6,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                ),
                label: Text(""),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width * 0.95,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MapWidget(
                    args["isSharee"],
                    args["userName"],
                    args["cryptoUsername"],
                    args["expiryTimeISO"],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
