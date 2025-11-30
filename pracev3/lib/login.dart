import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pracev3/paqagente.dart';

class LoginUsuario extends StatefulWidget{
  const LoginUsuario({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginUsuario>{
  final _usuarioController = TextEditingController();
  final _contraController = TextEditingController();
  Future<void> validarLogin() async{
    final url = Uri.parse('http://localhost:8000/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': _usuarioController.text,
        'passw_hash': _contraController.text,
      }),
    );
    print("response body: ${response.body}");
    if(response.statusCode == 200){
      final usuarioIns = jsonDecode(response.body);
      final id = usuarioIns['id_usr'];
      final usuario = usuarioIns['nom_usr'];
      final tipusr = usuarioIns['rol'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario válido $usuario con ID $id')),
      );
      if (tipusr==1){
        Navigator.pushNamed(context, '/panadmin');
        _usuarioController.clear();
        _contraController.clear();
      } else {
        Navigator.push(
          context,MaterialPageRoute(builder: (context)=>PaqueteEntregarList(full_name: usuario,user_id:id))
        );
        _usuarioController.clear();
        _contraController.clear();
      }
    }else{
      ScaffoldMessenger.of(
        context
        ).showSnackBar(SnackBar(content: Text('Usuario y/o contraseña incorrectos')));
    }
    print(response.statusCode);
  }
  // final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient:  LinearGradient(
              colors: [
                Color.fromARGB(255, 161, 72, 13),
                Color.fromARGB(255, 230, 155, 52),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Inicio de sesión',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Title(
                color:Color.fromARGB(255, 177, 59, 23),
                child: Text("Bienvenido a Paquexpress",style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 177, 59, 23)), textAlign: TextAlign.center),
              ),
              SizedBox(height: 10),
              Icon(Icons.account_circle_outlined, color: Colors.deepOrange, size: 100),
              SizedBox(height: 30),
              TextFormField(
                controller: _usuarioController,
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.person,color: Color.fromARGB(255, 150, 47, 0)),
                ),
                cursorColor: const Color.fromARGB(255, 150, 47, 0),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contraController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  // filled: true, //Para fondo del inputText
                  // fillColor: Color.fromARGB(44, 57, 169, 189),
                  labelText: "Contraseña",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.lock,color: Color.fromARGB(255, 150, 47, 0)),
                  
                ),
                cursorColor: const Color.fromARGB(255, 150, 47, 0),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: validarLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 155, 70, 0),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(95, 192, 156, 122),
    );
  }
}