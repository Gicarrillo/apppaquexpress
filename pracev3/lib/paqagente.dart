import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pracev3/foto.dart';
import 'package:pracev3/login.dart';
class PaqueteEntregarList extends StatelessWidget {
  final String full_name;
  final int user_id;

  const PaqueteEntregarList({super.key, required this.full_name, required this.user_id});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListaEntregasPage(
        full_name: full_name,
        user_id: user_id,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MenuLateral extends StatelessWidget{
  const MenuLateral({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 119, 19, 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle,size: 64,color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menú de agente",
                    style: TextStyle(color: Colors.white,fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text("Cerrar sesión"),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder:(context)=>LoginUsuario())
                );
              },
            )
          ],
        ),
      // ),
    );
  }
}
class ListaEntregasPage extends StatefulWidget {
  final String full_name;
  final int user_id;

  const ListaEntregasPage({super.key, required this.full_name, required this.user_id});

  @override
  _ListaEntregasPageState createState() => _ListaEntregasPageState();
}
class _ListaEntregasPageState extends State<ListaEntregasPage> {
  List<dynamic> paquetes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPaquetes();
  }

  Future cargarPaquetes() async {
    final url = Uri.parse("http://localhost:8000/paquetes/${widget.user_id}/");
    final response = await http.get(url);
    var decoded = utf8.decode(response.bodyBytes);
    paquetes = json.decode(decoded);
    setState(() => isLoading = false);
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
              'Paquexpress',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: MenuLateral(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
            decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 206, 158, 126),
                Color.fromARGB(255, 199, 90, 0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
            child: ListView.builder(
              itemCount: paquetes.length,
              itemBuilder: (context, index) {
                final paquete = paquetes[index];
                return Card(
                  child: ListTile(
                    trailing: Icon(Icons.camera_alt, size: 30),
                    title: Text(paquete["descripcion"],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text(paquete["direccion"],style: TextStyle(fontSize: 18),),
                    onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FotoEntregaPage(
                              idPaq: paquete['id_paq']
                            ),
                          ),
                        ).then((_) => cargarPaquetes()); // Recargar lista
                      },
                  ),
                );
              },
            ),
        )
    );
  }
}