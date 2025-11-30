import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pracev3/entregas.dart';
import 'package:pracev3/login.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:pracev3/seleccion.dart';
class Paneladmin extends StatefulWidget{
  const Paneladmin({super.key});
  @override
  _PanelAdminHome createState() => _PanelAdminHome();
}
class _PanelAdminHome extends State<Paneladmin>{
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
      drawer: const MenuLateral(),
      body: Center(
        child: Text('¡Bienvenido al panel de administrador!',style: TextStyle(fontSize: 30,color: const Color.fromARGB(255, 85, 43, 23),fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
      ),
      backgroundColor: const Color.fromARGB(255, 228, 201, 171),
    );
  }
}
//2.Menú lateral
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
                    "Menú",
                    style: TextStyle(color: Colors.white,fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: (){
                Navigator.pushNamed(
                  context,'/panadmin'
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Agregar usuario"),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context)=>FormRegistro())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_add),
              title: Text("Agregar Paquete"),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context)=>FormPaquete())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Ver Usuarios"),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context)=>ListaUsuarios())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text("Ver Paquetes"),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context)=>PaqueteEntregar())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_rounded),
              title: Text("Ver Entregas"),
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context)=>ListaEntregas()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text("Cerrar sesión"),
              onTap: (){
                Navigator.pushReplacement(
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
class FormRegistro extends StatefulWidget{
  const FormRegistro({super.key});
  @override
  _UsuarioFormState createState() => _UsuarioFormState();
}
class _UsuarioFormState extends State<FormRegistro>{
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwController = TextEditingController();
  Future<void> agregarUsuario() async{
    final url = Uri.parse('http://localhost:8000/registrar/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom_usr': _nombreController.text,
        'correo': _correoController.text,
        'passw_hash': _passwController.text,
        'rol': 2,
      }),
    );
    print("response body: ${response.body}");
    if(response.statusCode == 200 || response.statusCode ==201){
      final usuarioIns = jsonDecode(response.body);
      final id = usuarioIns['id_usr'];
      final nombre = usuarioIns['nom_usr'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado: $id - $nombre')),
      );
      _nombreController.clear();
      _correoController.clear();
      _passwController.clear();
      // _tipusuController.clear();
    }else{
      ScaffoldMessenger.of(
        context
        ).showSnackBar(SnackBar(content: Text('Error al insertar')));
    }
    print(response.statusCode);
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
              'Nuevo Agente',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: MenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.person,color: Color.fromARGB(255, 163, 57, 38)),
                ),
                cursorColor: const Color.fromARGB(255, 0, 10, 150),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _correoController,
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.mail,color: Color.fromARGB(255, 163, 57, 38)),
                  
                ),
                cursorColor: const Color.fromARGB(255, 0, 10, 150),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwController,
                decoration: InputDecoration(
                  labelText: "Establecer contraseña",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.lock,color: Color.fromARGB(255, 163, 57, 38)),
                ),
                cursorColor: const Color.fromARGB(255, 0, 10, 150),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: agregarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 64, 104),
                    foregroundColor: const Color.fromARGB(255, 212, 209, 209),
                  ),
                  child: Text('Guardar'),
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(41, 126, 39, 4),
    );
  }
}
class ListaUsuarios extends StatefulWidget{
  const ListaUsuarios({super.key});
  @override
  _UsuarioListState createState() => _UsuarioListState();
}
class _UsuarioListState extends State<ListaUsuarios>{
  List<dynamic> usuarios = [];
  Future<void> cargarUsuarios() async{
    final url = Uri.parse('http://localhost:8000/usuarios/');
    final response = await http.get(url);
    if(response.statusCode == 200){
      setState(() {
        usuarios = jsonDecode(response.body);
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar usuarios: ${response.statusCode}'),
        ),
      );
    }
  }
  @override
  void initState(){
    super.initState();
    cargarUsuarios();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 112, 42, 10),
                Color.fromARGB(255, 167, 70, 32),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Usuarios registrados',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: MenuLateral(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 206, 158, 126),
              Color.fromARGB(255, 199, 90, 0),
            ], //azul claro a azul oscuro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: usuarios.length,
          itemBuilder: (context, index){
            final listausr = usuarios[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  'Empleado con ID: ${listausr['id_usr']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('Nombre: ${listausr['nom_usr']}'),
                    Text('Correo: ${listausr['correo']}'),
                    Text('Rol: ${listausr['rol']==1 ? 'Administrador' : 'Empleado'}'
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class FormPaquete extends StatefulWidget{
  const FormPaquete({super.key});
  @override
  _FormPaqueteState createState() => _FormPaqueteState();
}
class _FormPaqueteState extends State<FormPaquete>{
  final _descripController = TextEditingController();
  LatLng? _ubicacionSeleccion;
  List<dynamic> usuarios = [];
  int? usrseleccionado;
  Future<void> cargarUsuarios() async{
    final url = Uri.parse('http://localhost:8000/usuarioslista/');
    final response = await http.get(url);
    if(response.statusCode == 200){
      setState(() {
        usuarios = jsonDecode(response.body);
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar usuarios: ${response.statusCode}'),
        ),
      );
    }
  }
  @override
  void initState(){
    super.initState();
    cargarUsuarios();
  }
  Future<void> agregarPaquete() async{
    if(_ubicacionSeleccion==null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes seleccionar una ubicación dentro del mapa."))
      );
      return;
    }
    final url = Uri.parse('http://localhost:8000/paquetes/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'descrip': _descripController.text,
        'latitud_p': _ubicacionSeleccion!.latitude,
        'longitud_p':_ubicacionSeleccion!.longitude,
        'id_usu':usrseleccionado,
      }),
    );
    print("response body: ${response.body}");
    if(response.statusCode == 200 || response.statusCode ==201){
      final paqueteIns = jsonDecode(response.body);
      final id = paqueteIns['id_paq'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paquete $id registrado correctamente')),
      );
      _descripController.clear();
      setState(() {
        _ubicacionSeleccion=null;
      });
    }else{
      ScaffoldMessenger.of(
        context
        ).showSnackBar(SnackBar(content: Text('Error al registrar el paquete')));
    }
    print(response.statusCode);
  }
  void seleccionubi() async{
      final LatLng? coordenada = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>SeleccionarUbicacionPage()),
      );
      if(coordenada!=null){
        setState(() {
          _ubicacionSeleccion = coordenada;
        });
      }
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
              'Nuevo Paquete',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: MenuLateral(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Agregar un nuevo paquete",
                style: TextStyle(color: const Color.fromARGB(255, 59, 17, 0), fontSize: 35, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: _descripController,
                decoration: InputDecoration(
                  labelText: "Descripción del paquete",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.insert_drive_file_rounded,color: Color.fromARGB(255, 163, 57, 38)),
                ),
                cursorColor: const Color.fromARGB(255, 0, 10, 150),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Elige a un agente para que entregue el paquete",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                value: usrseleccionado,
                items: usuarios.map<DropdownMenuItem<int>>((usr ){
                  return DropdownMenuItem<int>(
                    value: usr['id_usr'],
                    child: Text(usr['nom_usr']),
                  );
                }).toList(),
                onChanged:(value){
                  setState(() {
                    usrseleccionado=value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.map_sharp),
                label: Text("Seleccionar una ubicación de entrega"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 100, 15, 0),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: seleccionubi,
              ),
              const SizedBox(height: 20),
              if(_ubicacionSeleccion!=null)
              Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding:  const EdgeInsets.all(16),
                      child: Text(
                        "Ubicación:"
                        "\nLatitud: ${_ubicacionSeleccion!.latitude}"
                        "\nLongitud: ${_ubicacionSeleccion!.longitude}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: agregarPaquete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 64, 104),
                    foregroundColor: const Color.fromARGB(255, 212, 209, 209),
                  ),
                  child: Text('Guardar'),
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(41, 126, 39, 4),
    );
  }
}
class PaqueteEntregar extends StatefulWidget{
  const PaqueteEntregar({super.key});
  @override
  _PaqueteListState createState() => _PaqueteListState();
}
class _PaqueteListState extends State<PaqueteEntregar>{
  List<dynamic> paquetes = [];
  Future<void> cargarpaquetes() async{
    final url = Uri.parse('http://localhost:8000/paquetes/lista');
    final response = await http.get(url);
    var decoded = utf8.decode(response.bodyBytes);
    if(response.statusCode == 200){
      setState(() {
        paquetes = json.decode(decoded);
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar paquetes: ${response.statusCode}'),
        ),
      );
    }
  }
  @override
  void initState(){
    super.initState();
    cargarpaquetes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 112, 42, 10),
                Color.fromARGB(255, 167, 70, 32),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Paquetes agregados',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: MenuLateral(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 206, 158, 126),
              Color.fromARGB(255, 199, 90, 0),
            ], //azul claro a azul oscuro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: paquetes.length,
          itemBuilder: (context, index){
            final paquete = paquetes[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  'Paquete No. ${paquete['id_paq']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('Descripción de paquete: ${paquete['descrip']}'),
                    Text('Ubicación de entrega: ${paquete['direccion']}'),
                    Text('Agente asignado: ${paquete['id_usu']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class ListaEntregas extends StatefulWidget{
  const ListaEntregas({super.key});
  @override
  _EntregaListState createState() => _EntregaListState();
}
class _EntregaListState extends State<ListaEntregas>{
  List<dynamic> entregas = [];
  Future<void> cargarentregas() async{
    final url = Uri.parse('http://localhost:8000/entrega/lista/');
    final response = await http.get(url);
    var decoded = utf8.decode(response.bodyBytes);
    if(response.statusCode == 200){
      setState(() {
        entregas = jsonDecode(decoded);
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar entregas: ${response.statusCode}'),
        ),
      );
    }
  }
  @override
  void initState(){
    super.initState();
    cargarentregas();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 112, 42, 10),
                Color.fromARGB(255, 167, 70, 32),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Paquetes entregados',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: MenuLateral(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 206, 158, 126),
              Color.fromARGB(255, 199, 90, 0),
            ], //azul claro a azul oscuro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: entregas.length,
          itemBuilder: (context, index){
            final entrega = entregas[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  'Entrega No. ${entrega['id_ent']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('Paquete entregado - No. ${entrega['id_paq']}'),
                    Text('Fecha de entrega: ${entrega['fecha_ent']}'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListaEntregasAgente(entrega: entrega)));
                  },
                  icon: Icon(Icons.image_search,size: 20),
                )
              ),
            );
          },
        ),
      ),
    );
  }
}