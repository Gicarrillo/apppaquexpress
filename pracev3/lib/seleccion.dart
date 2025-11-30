// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SeleccionarUbicacionPage extends StatefulWidget {
  const SeleccionarUbicacionPage({super.key});

  @override
  State<SeleccionarUbicacionPage> createState() => _SeleccionarUbicacionPageState();
}

class _SeleccionarUbicacionPageState extends State<SeleccionarUbicacionPage> {
  LatLng? puntoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient:  LinearGradient(
              colors: [
                Color.fromARGB(255, 126, 56, 10),
                Color.fromARGB(255, 167, 93, 32),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Mapa de selección para entrega de paquete',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(20.5930843,-100.3928149),
          zoom: 15, 
          onTap: (tapPosition, latlng) {
            setState(() {
              puntoSeleccionado = latlng;
            });
            print("Tocado: ${latlng.latitude}, ${latlng.longitude}");
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),

          if (puntoSeleccionado != null)
            MarkerLayer(
              markers:[
              Marker(
                point: puntoSeleccionado!,
                width: 50,
                height: 50,
                builder:(BuildContext context)=> const Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (puntoSeleccionado != null) {
            Navigator.pop(context, puntoSeleccionado);
          }
        },
      ),
    );
  }
}