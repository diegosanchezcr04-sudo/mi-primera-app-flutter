class Producto {
  final int id;
  final String nombre;
  final int precio;

  Producto({required this.id, required this.nombre, required this.precio});

  // Este método toma un Map (que viene del JSON) y arma un Producto.
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['title'],
      precio: json['id'] * 100,
    );
  }
}