import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ApiService {
  static const String _url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Producto>> cargarProductos() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.take(15).map((e) => Producto.fromJson(e)).toList();
    }
    throw Exception('No se pudo cargar la información');
  }
}