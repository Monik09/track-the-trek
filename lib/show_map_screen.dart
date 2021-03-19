import "package:flutter/material.dart";
import 'package:share/share.dart';
import 'package:track_me_beacon/map_widget.dart';
import 'package:clipboard/clipboard.dart';

class ShowMapScreen extends StatefulWidget {
  static final String routeName = "/showMapScreen";
  @override
  _ShowMapScreenState createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.8,
                  // child: Container(),
                  child: MapWidget(
                      args["isSharee"],args["userName"],args["cryptoUsername"]
                      ),
                  // color: Colors.teal,
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(bottom:16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Share.share(
                          'Look, where I am I am sharing my location with a passkey as:' +
                                  args["cryptoUsername"] ??
                              "ak");
                    },
                    child: Text(
                      "Share Code",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FlutterClipboard.copy(args["cryptoUsername"] ?? "al")
                          .then((value) => print('copied'));
                    },
                    child: Text(
                      "Copy Code",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
