import 'dart:convert';

import "package:flutter/material.dart";
import 'dart:math' as math;
import 'package:track_me_beacon/show_map_screen.dart';
import 'package:track_me_beacon/wavy_header.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double duration;
  String username = "Anonymous";
  bool _isShareLocationDialog = false, _isViewDialog = false;
  final ScrollController scrollController = ScrollController();
  final FocusNode nameFieldNode = FocusNode();
  final FocusNode nameSubmitNode = FocusNode();
  static final _formKey = GlobalKey<FormState>();
  static final _formKey2 = GlobalKey<FormState>();
  final TextEditingController nameField = TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController durationController = new TextEditingController();
  String cryptoResult = '';
  math.Random random = math.Random();
  Color textColor = Colors.deepPurple;
  @override
  void initState() {
    var values = List<int>.generate(32, (i) => random.nextInt(256));
    cryptoResult = base64Url.encode(values);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          height: deviceHeight,
          child: Column(
            children: [
              WavyHeader(),
              FittedBox(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Flutter Beacon",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.08052681,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[100],
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          "See my friend's location",
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon((!_isViewDialog)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                        onTap: () {
                          setState(
                            () {
                              _isViewDialog = !_isViewDialog;
                              _isShareLocationDialog = false;
                            },
                          );
                        },
                      ),
                    ),
                    if (!_isShareLocationDialog && _isViewDialog)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.slowMiddle,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    icon: Icon(
                                      Icons.person_outline_sharp,
                                      color: Colors.teal,
                                    ),
                                    labelStyle: TextStyle(color: textColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: textColor,
                                      ),
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                  onEditingComplete: () {
                                    usernameController.value == null
                                        ? username = "Anonymous"
                                        : username = usernameController.text;
                                    FocusScope.of(context).nextFocus();
                                    print(username);
                                  },
                                ),
                                SizedBox(height: 5,),
                                TextFormField(
                                  enableSuggestions: true,
                                  maxLines: 1,
                                  focusNode: nameFieldNode,
                                  controller: nameField,
                                  style: TextStyle(color: Colors.teal),
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Passkey",
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: nameFieldNode.hasFocus
                                          ? Colors.teal
                                          : textColor,
                                    ),
                                    labelStyle: TextStyle(color: textColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: textColor,
                                      ),
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                        color: nameFieldNode.hasFocus
                                            ? Colors.teal
                                            : textColor,
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    return val == null || val.length == 0
                                        ? "Enter a passkey!"
                                        : null;
                                  },
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      focusNode: nameSubmitNode,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          print(nameField.text);
                                          Navigator.pushNamed(
                                              context, ShowMapScreen.routeName,
                                              arguments: {
                                                "isSharee": false,
                                                "userName": usernameController.text,
                                                "cryptoUsername": nameField.text
                                              });
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[100],
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          "Share my location",
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon((!_isShareLocationDialog)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                        onTap: () {
                          setState(
                            () {
                              _isViewDialog = false;
                              _isShareLocationDialog = !_isShareLocationDialog;
                            },
                          );
                        },
                      ),
                    ),
                    if (_isShareLocationDialog && !_isViewDialog)
                      shareLocationWidget(context, _formKey2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shareLocationWidget(
      BuildContext context, GlobalKey<FormState> _formKey) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                icon: Icon(
                  Icons.person_outline_sharp,
                  color: Colors.teal,
                ),
                labelStyle: TextStyle(color: textColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                    color: textColor,
                  ),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                    color: Colors.teal,
                  ),
                ),
              ),
              onEditingComplete: () {
                usernameController.value == null
                    ? username = "Anonymous"
                    : username = usernameController.text;
                FocusScope.of(context).nextFocus();
                print(username);
              },
            ),
            TextFormField(
              controller: durationController,
              decoration: InputDecoration(
                labelText: "Duration",
                hintText: "Enter duration of sharing (in minutes)",
                icon: Icon(Icons.timelapse_sharp, color: Colors.teal),
                labelStyle: TextStyle(color: textColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                    color: textColor,
                  ),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                    color: Colors.teal,
                  ),
                ),
              ),
              validator: (val) {
                try {
                  duration = double.parse(durationController.text);
                  if (duration <= 0) {
                    return "Enter value greater than 0";
                  }
                } catch (e) {
                  return "Enter a integer value";
                }

                return null;
              },
              onChanged: (val) {
                if (_formKey.currentState.validate()) {
                  durationController.value == null
                      ? duration = 1
                      : duration = double.parse(durationController.text);
                }
                print(duration);
              },
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print(username);
                    print(duration);
                    FocusScope.of(context).unfocus();
                    Navigator.pushNamed(context, ShowMapScreen.routeName,
                        arguments: {
                          "isSharee": true,
                          "userName": username,
                          "cryptoUsername": cryptoResult,
                          "expiryTimeISO": DateTime.now()
                              .toUtc()
                              .add(Duration(seconds: (duration * 60).toInt()))
                              .toIso8601String(),
                        });
                    durationController.clear();
                    usernameController.clear();
                  }
                },
                child: Text(
                  "Share my Location",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
