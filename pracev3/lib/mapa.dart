import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget{
  // const MapScreen({super.key});

  final double latitude,longitud; 

  const MapScreen({super.key, required this.latitude, required this.longitud});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 38, 131, 119),
                Color.fromARGB(255, 25, 210, 164),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Mapa de ubicación',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(latitude, longitud),
          minZoom: 5,
          maxZoom: 100,
          zoom: 18
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a','b','c'],
          ),
          MarkerLayer(
            markers: <Marker> [
              Marker(
                point: LatLng(latitude, longitud),
                builder: (BuildContext context) => Icon(Icons.pin_drop, color: Colors.red),
              ),
            ],
          )
        ],
      ),
    );
  }
}