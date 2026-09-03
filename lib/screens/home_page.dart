import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import 'bitacora_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Producto>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo - FrutiApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ver Bitácora',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BitacoraPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No se pudo cargar la información.'));
          }

          final productos = snapshot.data!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        producto.nombre,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Precio: ${producto.precio} colones',
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                        '#${producto.id}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}