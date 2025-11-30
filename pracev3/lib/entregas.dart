import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ListaEntregasAgente extends StatelessWidget {
  final dynamic entrega;

  const ListaEntregasAgente({super.key, required this.entrega});

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
            title: Text("Información de entrega: ${entrega['id_ent']}",style: TextStyle(fontSize: 22, color: Colors.white))
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "📍 Ubicación:\n${entrega["direc"]}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            entrega['foto'] == null
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("No hay foto de la entrega"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network("http://localhost:8000/"+entrega['foto'],width: 250,height: 250,fit: BoxFit.cover)
                    ),
                  ),
            const SizedBox(height: 10),
            SizedBox(
              height: 400, width: 450,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(entrega['lat'], entrega['lon']),
                  zoom: 15, 
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a','b','c'],
                  ),
                  MarkerLayer(
                    markers: <Marker> [
                      Marker(
                        point: LatLng(entrega['lat'], entrega['lon']),
                        width: 40,
                        height: 40,
                        builder: (BuildContext contex)=>Icon(Icons.location_history,color: const Color.fromARGB(255, 160, 11, 0))
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 163, 93, 47),
    );
  }
}
