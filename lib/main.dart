import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

import 'Libro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookish APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'BookishAPP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Libro> libros = [];

  @override
  void initState() {
    super.initState();
    _leerLibros();
  }

  Future<void> _leerLibros() async {
    final data =
        await DefaultAssetBundle.of(context).loadString('assets/libros.xml');

    final document = xml.parse(data);
    final elementos = document.findAllElements('libro');

    setState(() {
      libros = elementos.map((elemento) {
        final titulo = elemento.findElements('titulo').single.text;
        final autor = elemento.findElements('autor').single.text;
        final precio =
            double.parse(elemento.findElements('precio').single.text);
        return Libro(titulo: titulo, autor: autor, precio: precio);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de libros'),
      ),
      body: ListView.builder(
        itemCount: libros.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(
                  libros[index].titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Autor: ${libros[index].autor}'),
                    Text(
                      'Precio: \$${libros[index].precio.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
