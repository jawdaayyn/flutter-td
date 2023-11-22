import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  Position maPostion;
  MyMap({required this.maPostion, super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  //variable
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition initCamera;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera = CameraPosition(
        target: LatLng(widget.maPostion.latitude, widget.maPostion.longitude),
        zoom: 14);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) async {
        String newStyle = await DefaultAssetBundle.of(context)
            .loadString("lib/mapStyle.json");
        controller.setMapStyle(newStyle);
        completer.complete(controller);
      },
      initialCameraPosition: initCamera,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }
}
