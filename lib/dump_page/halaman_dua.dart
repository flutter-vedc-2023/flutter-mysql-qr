// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:modul_flutter/screens/scanpage.dart';
//import 'package:modul_flutter/screens/generatepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class HalamanDua extends StatefulWidget {
  const HalamanDua({Key? key}) : super(key: key);

  @override
  _HalamanDuaState createState() => _HalamanDuaState();
}

class _HalamanDuaState extends State<HalamanDua> {
  String lokasi = "";
  String alamat = "";
  String status = "";
  LatLng initialLocation = LatLng(-7.933283, 112.660648);
  bool isInArea = false;

  List<LatLng> polygonPoints = [
    LatLng(-7.933264, 112.660046),
    LatLng(-7.933490, 112.660087),
    LatLng(-7.933502, 112.660499),
    LatLng(-7.933269, 112.660612)
  ];
  late GoogleMapController _googleMapController;

  void checkUpdatedLocation(LatLng pointLatLng) {
    List<map_tool.LatLng> convatedPolygonPoints = polygonPoints
        .map((point) => map_tool.LatLng(point.latitude, point.longitude))
        .toList();
    setState(() {
      if (isInArea = map_tool.PolygonUtil.containsLocation(
          map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
          convatedPolygonPoints,
          false)) {
        lokasi = 'Taman BBPPMPV BOE MALANG';
        alamat = 'Arjosari, Kota Malang, Jawa Timur';
        status = 'Berada';
      } else {
        alamat = 'Diluar BBPPMPV BOE MALANG';
        lokasi = 'Diluar BBPPMPV BOE MALANG';
        status = 'Tidak Berada';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Halaman dua',
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Lokasi anda saat ini')),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    lokasi,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    alamat,
                    style: TextStyle(fontSize: 17),
                  )),
              SizedBox(
                height: 40,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                      'Anda $status di dalam titik radius untuk presensi')),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: isInArea ? () {} : null,
                child: const Text('Konfirmasi'),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialLocation,
              zoom: 19,
            ),
            markers: {
              Marker(
                  markerId: MarkerId('demo'),
                  position: initialLocation,
                  draggable: true,
                  onDragEnd: (updatedLatLng) {
                    checkUpdatedLocation(updatedLatLng);
                  })
            },
            polygons: {
              Polygon(
                  polygonId: PolygonId("1"),
                  points: polygonPoints,
                  fillColor: Color(0xFF006491).withOpacity(0.2),
                  strokeWidth: 2,
                  strokeColor: Colors.grey),
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
