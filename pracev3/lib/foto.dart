import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class FotoEntregaPage extends StatefulWidget {
  final int idPaq;
  const FotoEntregaPage({super.key, required this.idPaq});

  @override
  _FotoEntregaPageState createState() => _FotoEntregaPageState();
}
class _FotoEntregaPageState extends State<FotoEntregaPage> {
  Uint8List? _imageBytes;
  XFile? _pickedFile;
  final picker = ImagePicker();
  bool envio = false;

  Future tomarFoto() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _pickedFile = picked;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Foto tomada")));
    }
  }
  Future enviarEntrega() async {
  if (_imageBytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Primero toma una foto")),
    );
    return;
  }

  setState(() => envio = true);
  Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  final entregaResponse = await http.post(
    Uri.parse("http://localhost:8000/entrega/"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "id_paq": widget.idPaq,
      "latit_ent": pos.latitude,
      "long_ent": pos.longitude
    }),
  );
    var data = jsonDecode(entregaResponse.body);
    var id = data['id_ent'];
  if (entregaResponse.statusCode != 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al registrar entrega")),
    );
    setState(() => envio = false);
    return;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Se ha realizado la entrega $id")),
    );
    setState(() => envio = true);
  }

  final entregaData = jsonDecode(entregaResponse.body);
  int id_ent = entregaData["id_ent"];
  var request = http.MultipartRequest(
    'POST', Uri.parse("http://localhost:8000/fotos/$id_ent"));
  request.files.add(http.MultipartFile.fromBytes('file', _imageBytes!, filename: _pickedFile!.name));
  var response = await request.send();
  if (response.statusCode == 200) {
    Navigator.pop(context); 
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al subir la foto")),
    );
  }
  setState(() => envio = false);
}
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
              'Verificación de Entrega',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes == null
                ? const Text("No hay foto", style: TextStyle(fontSize: 20))
                : Image.memory(_imageBytes!, height: 300),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: tomarFoto,
              child: const Text("Tomar foto"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 107, 21, 0),
                foregroundColor: Colors.white
              )
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: envio ? null : enviarEntrega,
              child: envio
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Enviar entrega"),
              
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 107, 21, 0),
                foregroundColor: Colors.white
              )
            ),
          ],
        ),
        )
      ),
    );
  }
}

