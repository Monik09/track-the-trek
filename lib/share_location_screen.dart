import 'package:flutter/material.dart';

class ShareLocationScreen extends StatefulWidget {
  static final String routeName = "/shareLocationScreen";

  @override
  _ShareLocationScreenState createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  final TextEditingController usernameController = new TextEditingController();
  String username = "";
  int duration;
  final TextEditingController durationController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ScaffoldState _scaffoldState = new ScaffoldState();
  // var _dateTime, _currentValue = 1, _currentIntValue = 0;
  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.purple;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    icon: Icon(Icons.person_outline_sharp, color: Colors.teal),
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
                // TextButton(
                //   child: Text("Choose duration: "),
                //   onPressed: () {
                //     _scaffoldState.showBottomSheet<void>(
                //       // context:context,
                //       (BuildContext context) {
                //         // shape: RoundedRectangleBorder(
                //         //   borderRadius: BorderRadius.only(
                //         //     topLeft: Radius.circular(25),
                //         //     topRight: Radius.circular(25),
                //         //   ),
                //         // ),
                //         // builder: (_) {
                //         return Container(
                //           height: MediaQuery.of(context).size.height * 0.4,
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Card(
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.only(
                //                     topLeft: Radius.circular(15),
                //                     topRight: Radius.circular(15),
                //                   ),
                //                 ),
                //                 child: NumberPicker(
                //                     value: _currentValue,
                //                     minValue: _currentValue,
                //                     maxValue: 59,
                //                     // itemHeight: 60,

                //                     onChanged: (value) {
                //                       setState(() => _currentValue = value);
                //                     }),
                //               ),
                //               NumberPicker(
                //                 value: _currentIntValue,
                //                 minValue: 0,
                //                 maxValue: 100,
                //                 step: 10,
                //                 haptics: true,
                //                 onChanged: (value) =>
                //                     setState(() => _currentIntValue = value),
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),
                // Container(
                //   width: double.maxFinite,
                //   child: Row(
                //     children: [
                // Text(
                //   "Enter duration\n(in mins):",
                // ),
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  width: double.maxFinite,
                  child: TextFormField(
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
                        duration = int.parse(durationController.text);
                      } catch (e) {
                        return "Enter a integer value";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState.validate()) {
                        durationController.value == null
                            ? duration = 1
                            : duration = int.parse(durationController.text);
                      }
                      print(duration);
                    },
                  ),
                ),
                ElevatedButton(
                  autofocus: true,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print(username);
                      print(duration);
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Text(
                    "Share my Location",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget shareLocationWidget(BuildContext context) {
    Color textColor = Colors.purple;
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                icon: Icon(Icons.person_outline_sharp, color: Colors.teal),
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
            // TextButton(
            //   child: Text("Choose duration: "),
            //   onPressed: () {
            //     _scaffoldState.showBottomSheet<void>(
            //       // context:context,
            //       (BuildContext context) {
            //         // shape: RoundedRectangleBorder(
            //         //   borderRadius: BorderRadius.only(
            //         //     topLeft: Radius.circular(25),
            //         //     topRight: Radius.circular(25),
            //         //   ),
            //         // ),
            //         // builder: (_) {
            //         return Container(
            //           height: MediaQuery.of(context).size.height * 0.4,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Card(
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(15),
            //                     topRight: Radius.circular(15),
            //                   ),
            //                 ),
            //                 child: NumberPicker(
            //                     value: _currentValue,
            //                     minValue: _currentValue,
            //                     maxValue: 59,
            //                     // itemHeight: 60,

            //                     onChanged: (value) {
            //                       setState(() => _currentValue = value);
            //                     }),
            //               ),
            //               NumberPicker(
            //                 value: _currentIntValue,
            //                 minValue: 0,
            //                 maxValue: 100,
            //                 step: 10,
            //                 haptics: true,
            //                 onChanged: (value) =>
            //                     setState(() => _currentIntValue = value),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            // Container(
            //   width: double.maxFinite,
            //   child: Row(
            //     children: [
            // Text(
            //   "Enter duration\n(in mins):",
            // ),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: TextFormField(
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
                    duration = int.parse(durationController.text);
                  } catch (e) {
                    return "Enter a integer value";
                  }
                  return null;
                },
                onChanged: (val) {
                  if (_formKey.currentState.validate()) {
                    durationController.value == null
                        ? duration = 1
                        : duration = int.parse(durationController.text);
                  }
                  print(duration);
                },
              ),
            ),
            ElevatedButton(
              autofocus: true,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(username);
                  print(duration);
                  FocusScope.of(context).unfocus();
                }
              },
              child: Text(
                "Share my Location",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
