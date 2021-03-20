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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      key:_scaffoldKey,
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
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Card(
                // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  alignment: Alignment.centerLeft,
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  // child: Container(),
                  child: MapWidget(
                      args["isSharee"], args["userName"],
                      args["cryptoUsername"],args["expiryTimeISO"]
                      ),
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.share_sharp),
                      onPressed: () {
                        Share.share(
                            'Look, where I am. I am sharing my location with a passkey as:' +
                                args["cryptoUsername"]);
                      },
                      color: Colors.white,
                      iconSize: 30,
                    ),
                    radius: 25,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.copy_sharp),
                      onPressed: () {
                        ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
                            SnackBar(content: Text("Passkey Copied")));
                        FlutterClipboard.copy(args["cryptoUsername"])
                            .then((value) => print('copied'));
                      },
                      color: Colors.white,
                      iconSize: 30,
                    ),
                    radius: 25,
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
