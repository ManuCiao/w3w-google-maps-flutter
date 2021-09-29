import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:what3words/what3words.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  // String apiKey = dotenv.get('W3W_API_KEY');
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key ? key
  }): super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class LocationForm extends StatefulWidget {
  @override
  LocationFormState createState() {
    return LocationFormState();
  }
}

class LocationFormState extends State < LocationForm > {
  String twaHolder = '';

  var api = What3WordsV3(dotenv.get('W3W_API_KEY'));

  final _formKey = GlobalKey < FormState > ();

  @override
  Widget build(BuildContext context) {
    var twaController = TextEditingController();
    var twaInput = TextFormField(
      controller: twaController,
      decoration: InputDecoration(
        hintText: 'e.g. lock.spout.radar'
      ),
    );

    var convertToCoordsButton = ElevatedButton(
      onPressed: () async {
        var location = await api.convertToCoordinates(twaController.text).execute();
        setState(() {
          if (location.isSuccessful()) {
            twaHolder = '${location.data()!.coordinates.lat}, ${location.data()!.coordinates.lng}';
            print(twaHolder);
          } else {
            twaHolder = '${location.error()!.code}: ${location.error()!.message}';
            print(twaHolder);
          }
        });
      },
      child: Text('Convert To Coordinates'),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: < Widget > [
          twaInput,
          convertToCoordsButton,
          Text('$twaHolder', style: TextStyle(fontSize: 21))
        ],
      ),
    );
  }
}

class _MyAppState extends State < MyApp > {
  GlobalKey _mapKey = GlobalKey();
  final Map < String,
  Marker > _markers = {};
  var gridData;
  var api = What3WordsV3(dotenv.get('W3W_API_KEY'));

  List < Polyline > myPolyline = [];

  void _onMapCreated(GoogleMapController controller) async {


    // get zoom
    // final double zoomLevel = await controller.getZoomLevel();


    // get boundingbox of sw and ne
    // LatLngBounds l1 = await controller.getVisibleRegion();
    LatLng sw = LatLng(51.515900, -0.212517);
    LatLng ne = LatLng(51.527649, -0.191746);
    LatLngBounds bounds = LatLngBounds(southwest: sw, northeast: ne);
    // print(bound);

    // resize the camera
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
    controller.animateCamera(cameraUpdate);

    // Call the what3words Grid API to obtain the grid squares within the current visible bounding box
    final gridSection = await api
      .gridSection(Coordinates(sw.latitude, sw.longitude), Coordinates(ne.latitude, ne.longitude))
      .execute();
    // if (gridSection.isSuccessful()) {
    //   print(gridSection.data()?.toJson());
    // } 
    gridData = gridSection.data()!.toJson();
    // print(gridData);
    for (final coords in gridData) {
      print(coords);
    }

    createPolyline() {
      // myPolyline.add(gridData);
      myPolyline.add(
        Polyline(
          polylineId: PolylineId('1'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.515901250539024,-0.212517),
            LatLng(51.515901250539024,-0.191746)
          ]
        )
      );
       myPolyline.add(
        Polyline(
          polylineId: PolylineId('2'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.51592820181112,-0.212517),
            LatLng(51.51592820181112,-0.191746)
          ]
        )
      );
      myPolyline.add(
        Polyline(
          polylineId: PolylineId('3'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.51595515308322,-0.212517),
            LatLng(51.51595515308322,-0.191746)
          ]
        )
      );
       myPolyline.add(
        Polyline(
          polylineId: PolylineId('4'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.51598210435532,-0.212517),
            LatLng(51.51598210435532,-0.191746)
          ]
        )
      );
      myPolyline.add(
        Polyline(
          polylineId: PolylineId('5'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.516009055627414,-0.212517),
            LatLng(51.516009055627414,-0.191746)
          ]
        )
      );
       myPolyline.add(
        Polyline(
          polylineId: PolylineId('6'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.51603600689951,-0.212517),
            LatLng(51.51603600689951,-0.191746)
          ]
        )
      );
      myPolyline.add(
        Polyline(
          polylineId: PolylineId('7'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.51606295817161,-0.212517),
            LatLng(51.51606295817161,-0.191746)
          ]
        )
      );
       myPolyline.add(
        Polyline(
          polylineId: PolylineId('8'),
          color: Colors.blue,
          width: 3,
          points: [
            LatLng(51.51608990944371,-0.212517),
            LatLng(51.51608990944371,-0.191746)
          ]
        )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('W3W ON GOOGLE MAPS'),
            backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: < Widget > [
            Container(
              child: SizedBox(
                height: 600.0,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  // mapType: MapType.satellite,
                  // myLocationEnabled: true,
                  // trafficEnabled: true,
                  initialCameraPosition:
                  const CameraPosition(
                      target: LatLng(51.52086, -0.195499),
                      zoom: 17.0,
                    ),
                    polylines: myPolyline.toSet(),
                )
              ),
            ),
            Expanded(child: LocationForm())
          ]
        )
      ),
    );
  }
}


// getZoom
// const zoom = map.getZoom();
// const loadFeatures = zoom > 17;

// if (loadFeatures) {
//   // Zoom level is high enough
//   var ne = map.getBounds().getNorthEast();
//   var sw = map.getBounds().getSouthWest();

//   // Call the what3words Grid API to obtain the grid squares within the current visble bounding box
//   what3words.api
//     .gridSectionGeoJson({
//       southwest: {
//         lat: sw.lat(),
//         lng: sw.lng()
//       },
//       northeast: {
//         lat: ne.lat(),
//         lng: ne.lng()
//       }
//     })
//     .then(function (data) {
//       if (gridData !== undefined) {
//         for (var i = 0; i < gridData.length; i++) {
//           map.data.remove(gridData[i]);
//         }
//       }
//       gridData = map.data.addGeoJson(data);
//     })
//     .catch(console.error);
// }
// Create and execute a request to obtain a grid section within the provided bounding box (sw and ne corners)