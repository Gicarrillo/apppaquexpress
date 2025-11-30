import 'package:flutter/material.dart';
import 'package:pracev3/login.dart';
import 'package:pracev3/panadmin.dart';
void main()=> runApp(BlogApp());
class BlogApp extends StatelessWidget{
  const BlogApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paquexpress App',
      initialRoute: '/',
      routes: {
        '/':(context)=>LoginUsuario(),
        '/panadmin':(context)=>Paneladmin(),
      },
    );
  }
}