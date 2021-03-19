import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final bool isSharee;
  final String userName;
  final String cryptoUsername;
  MapWidget(this.isSharee, this.userName, this.cryptoUsername);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool isSharee = false;
  String userName = "TSET";
  String cryptoResult = "";
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Set<Marker> _marker = Set<Marker>();
  Location location;
  int i = 0;
  LocationData currentLocationData;
  LocationData locationDataForViewer;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    isSharee = widget.isSharee;
    userName = widget.userName;
    cryptoResult = widget.cryptoUsername;
    log(isSharee.toString() + " " + userName);
    log("h1");
    location = new Location();
    if (isSharee) {
      log("h2");
      location.onLocationChanged.listen((LocationData cLoc) {
        // setState(() {
        currentLocationData = cLoc;
        // });
        //data save
        log("I am changing!!-> " + currentLocationData.toString());
        submitUserData(cLoc);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(cLoc.latitude, cLoc.longitude),
              zoom: 16.4746,
            ),
          ),
        );
      });
    } else {
      // readData();
      log("in else part");
      var map;
      databaseReference.child("locData").child(cryptoResult).onValue.listen(
        (event) {
          map = event.snapshot.value;
          log("________" + map.toString());
          LocationData results = LocationData.fromMap(
            {
              "latitude": double.parse(map["lat"].toString()),
              "longitude": double.parse(map["lon"].toString()),
            },
          );
          setState(() {
            currentLocationData = results;
          });
          if (i != 0)
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(currentLocationData.latitude,
                      currentLocationData.longitude),
                  zoom: 16.4746,
                ),
              ),
            );
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
  }

  Future<void> submitUserData(LocationData cLoc) async {
    log(cryptoResult);
    var result = await http.put(
      // "https://cf-pursuit-default-rtdb.firebaseio.com/users/$userName.json",
      Uri.parse(
          "https://track-me-beacon-default-rtdb.firebaseio.com/locData/$cryptoResult.json"),
      body: json.encode(
        {
          "lat": cLoc.latitude,
          "lon": cLoc.longitude,
        },
      ),
    );
    if (result.statusCode == 200) {
      log("hurray!User details added successfully!!");
    } else {
      print(result.body);
      log("nope,error in adding user to database");
    }
  }

  // void readData() {
  //   List<double> l = [1, 1];
  //   int i = 0;
  //   databaseReference
  //       .child("locData")
  //       .child(cryptoResult)
  //       .onChildChanged
  //       .listen(
  //     (event) {
  //       (i % 2 == 0)
  //           ? l[0] = event.snapshot.value
  //           : l[1] = event.snapshot.value;
  //       i = 1 - i;
  //       // log("[[[][][][][->......." + event.snapshot.value.toString());
  //       log("_________-----LAtitude________" + l[0].toString());
  //       log("_________-----Longitude________" + l[1].toString());
  //       LocationData results =
  //           LocationData.fromMap({"latitude": l[0], "longitude": l[1]});
  //       // setState(() {
  //       currentLocationData = results;
  //       mapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //               target: LatLng(currentLocationData.latitude,
  //                   currentLocationData.longitude),
  //               zoom: 15.780),
  //         ),
  //       );
  //       // });
  //       log("--------------------------------------------->>>>>>>>>>>>" +
  //           results.toString());
  //     },
  //   );

  // }
  // );

  // var result = await http.get(
  //   // "https://cf-pursuit-default-rtdb.firebaseio.com/users/$userName.json",
  //   Uri.parse(
  //       "https://track-me-beacon-default-rtdb.firebaseio.com/locData/$cryptoResult.json"),
  // );
  // if (result.statusCode == 200) {
  //   log("*****************************" + result.body.toString());
  // } else {
  //   print(result.body);
  //   log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!nope,error in adding user to database");
  // }

  void setInitialLocation() async {
    currentLocationData = await location.getLocation();
    log("currentLocation Data " + currentLocationData.toString());
  }

  // void updatePinOnMap() async {
  //   CameraPosition cPosition = CameraPosition(
  //     zoom: 14,
  //     tilt: 59.440717697143555,
  //     bearing: 192.8,
  //     target:
  //         LatLng(currentLocationData.latitude, currentLocationData.longitude),
  //   );

  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  //   setState(() {
  //     var pinPosition =
  //         LatLng(currentLocationData.latitude, currentLocationData.longitude);
  //     _marker.removeWhere((m) => m.markerId.value == "sourcePin");
  //     _marker.add(Marker(
  //       markerId: MarkerId("sourcePin"),
  //       position: pinPosition, // updated position
  //     ));
  //   });
  // }
  // lu-kIfUIP5ckS9gOo0AxQPCIGoFP20sFanxgHeBmJGs=

  @override
  Widget build(BuildContext context) {
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(30.3398, 76.3869),
      zoom: 16.4746,
      bearing: 20,
      tilt: 50,
    );
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
              bearing: 20,
              tilt: 50,
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
                mapController = controller;
                _controller.complete(controller);
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
