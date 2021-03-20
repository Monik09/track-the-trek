import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final bool isSharee;
  final String userName;
  final String cryptoUsername;
  final String expiryTime;
  MapWidget(this.isSharee, this.userName, this.cryptoUsername, this.expiryTime);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
    with AutomaticKeepAliveClientMixin {
  bool isSharee = true;
  String userName = "";
  String cryptoResult = "";
  String expiryTime = "a";
  double durationHosting = 1;
  bool isTimeout = false;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Set<Marker> _marker = Set<Marker>();
  Location location;
  int i = 0;
  LocationData currentLocationData;
  LocationData locationDataForViewer;
  var dbListener;
  final databaseReference = FirebaseDatabase.instance.reference();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    isSharee = widget.isSharee;
    userName = widget.userName;
    expiryTime = widget.expiryTime;
    cryptoResult = widget.cryptoUsername;
    log(isSharee.toString() + " " + userName);
    log("h1");
    location = new Location();
    location.isBackgroundModeEnabled();

    if (isSharee) {
      log("h2");
      dbListener = location.onLocationChanged.listen((LocationData cLoc) {
        currentLocationData = cLoc;
        //data save
        log("I am changing!!-> " + currentLocationData.toString());
        // SchedulerBinding.instance
        //     .addPostFrameCallback((_) =>
        submitUserData(cLoc);
        //  );
        if (isTimeout) {
          log("inside timeout");
        }
        if (_controller.isCompleted) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(cLoc.latitude, cLoc.longitude),
                zoom: 16.4746,
              ),
            ),
          );
        }
      });
    } else {
      // readData();
      log("in else part");
      var map;
      dbListener =
          databaseReference.child("locData").child(cryptoResult).onValue.listen(
        (event) {
          map = event.snapshot.value;
          log("________" + map.toString());
          print("_______________" + map.toString());
          LocationData results = LocationData.fromMap(
            {
              "latitude": double.parse(map["lat"].toString()),
              "longitude": double.parse(map["lon"].toString()),
            },
          );
          log(isTimeout.toString());
          setState(() {
            currentLocationData = results;
          });
          if (i != 0) {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(currentLocationData.latitude,
                      currentLocationData.longitude),
                  zoom: 16.4746,
                ),
              ),
            );
          }
          log(isTimeout.toString());
          print(map["passkeyExpiryUTC"].toString() +
              "   " +
              (DateTime.now().toUtc().toIso8601String()));
          if (map["passkeyExpiryUTC"]
                  .toString()
                  .compareTo(DateTime.now().toUtc().toIso8601String()) <=
              0) {
            isTimeout = true;
            log(isTimeout.toString());
            // setState(() {
            isTimeout = true;
            // });
          }
          i = 1;
          log("i<--->" + i.toString());
          log(currentLocationData.toString());
        },
        onError: (e) {
          log("error" + e.toString());
        },
      );
    }
    log("h3");
    // if (isSharee) {
    log("h4.1");
    setInitialLocation();
    log("4.2");
    // }
    log("h5");
    if (currentLocationData != null)
      _marker.add(Marker(
        markerId: MarkerId('sourcePin'),
        position:
            LatLng(currentLocationData.latitude, currentLocationData.longitude),
      ));
    log("h6");
  }

  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  void handleTimeout(BuildContext context) async {
    log(isTimeout.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  child: Text(
                    'The passkey expired! Try reaching out to host for new passkey!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).push;
                    // Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!timeout");
    log(isTimeout.toString());
  }

  int k = 0;
  Future<void> submitUserData(LocationData cLoc) async {
    log(cLoc.toString());
    log(cryptoResult);
    try {
      var result = await http.put(
        // "https://cf-pursuit-default-rtdb.firebaseio.com/users/$userName.json",
        Uri.parse(
            "https://track-me-beacon-default-rtdb.firebaseio.com/locData/$cryptoResult.json"),
        body: json.encode(
          {
            "lat": cLoc.latitude,
            "lon": cLoc.longitude,
            "passkeyExpiryUTC": expiryTime,
          },
        ),
      );
      if (result.statusCode == 200 && k == 0) {
        Map<String, dynamic> mapData =
            json.decode(result.body.toString()) as Map<String, dynamic>;
        log(mapData.toString());
        log(mapData["passkeyExpiryUTC"].toString() +
            "      " +
            DateTime.now().toUtc().toIso8601String());
        log(isTimeout.toString());
        if (mapData["passkeyExpiryUTC"]
                .toString()
                .compareTo(DateTime.now().toUtc().toIso8601String()) <=
            0) {
          k = 1;
          log(isTimeout.toString());
          log("Timeout!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
          isTimeout = true;
          log(isTimeout.toString());
          setState(() {
            isTimeout = true;
          });
        }
        log("hurray!User details added successfully!!");
        log(isTimeout.toString());
      } else {
        log(result.body);
        log("nope,error in adding user to database");
        log(isTimeout.toString());
      }
    } catch (e) {
      log(e.message);
    }
  }

  void setInitialLocation() async {
    currentLocationData = await location.getLocation();
    log("currentLocation Data " + currentLocationData.toString());
  }

  @override
  void didChangeDependencies() {
    if (isTimeout)
      SchedulerBinding.instance
          .addPostFrameCallback((_) => handleTimeout(context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(30.3398, 76.3869),
      zoom: 16.4746,
      // bearing: 20,
      // tilt: 50,
    );
    log("inside build");
    if (isTimeout)
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        content: Text(
          'The passkey expired! Try reaching out to host for new passkey!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              alignment: Alignment.center,
            ),
            onPressed: () {
              // Navigator.of(context).push;
              // Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
        ],
        elevation: 30,
      );
    // return Dialog(
    //   // context: context,
    //   // builder: (BuildContext context) =>
    //   child: Center(
    //     child: Container(
    //       height: 120,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.all(
    //           Radius.circular(16),
    //         ),
    //         color: Colors.white30,
    //       ),
    //       width: MediaQuery.of(context).size.width * 0.9,
    //       padding: EdgeInsets.symmetric(horizontal: 16),
    //       child: Column(
    //         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Container(
    //             height: 70,
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               border: Border(
    //                 bottom: BorderSide(
    //                   width: 1,
    //                   color: Colors.grey[300],
    //                 ),
    //               ),
    //             ),
    //             child: Text(
    //               'The passkey expired! Try reaching out to host for new passkey!',
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               // Navigator.of(context).push;
    //               // Navigator.of(context).pop();
    //               Navigator.of(context).pop();
    //             },
    //             child: Text(
    //               "OK",
    //               style: TextStyle(fontSize: 18),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: FutureBuilder(
        future: location.getLocation(),
        builder: (context, futureData) {
          log("hb1");
          if (futureData.hasData) {
            LocationData curr;
            curr = futureData.data;
            _kGooglePlex = CameraPosition(
              target: currentLocationData != null
                  ? LatLng(currentLocationData.latitude,
                      currentLocationData.longitude)
                  : LatLng(curr.latitude, curr.longitude),
              zoom: 16.4746,
              // bearing: 20,
              // tilt: 50,
            );

            return GoogleMap(
              markers: !isSharee
                  ? {
                      Marker(
                        markerId: MarkerId("Host"),
                        position: currentLocationData != null
                            ? LatLng(currentLocationData.latitude,
                                currentLocationData.longitude)
                            : LatLng(curr.latitude, curr.longitude),
                      ),
                    }
                  : {}, //_marker,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                  mapController = controller;
                }
              },
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              trafficEnabled: true,
              buildingsEnabled: true,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
