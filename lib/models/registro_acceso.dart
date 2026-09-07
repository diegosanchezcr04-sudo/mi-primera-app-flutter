class RegistroAcceso {
  final String usuario;
  final DateTime fechaHora;
  final String resultado;

  const RegistroAcceso({
    required this.usuario,
    required this.fechaHora,
    required this.resultado,
  });

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'fechaHora': fechaHora.toIso8601String(),
        'resultado': resultado,
      };

  factory RegistroAcceso.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'];
    final fechaHora = json['fechaHora'];
    final resultado = json['resultado'];

    if (usuario is! String || fechaHora is! String || resultado is! String) {
      throw const FormatException(
        'Cada registro debe incluir usuario, fechaHora y resultado como texto.',
      );
    }
    if (resultado != 'AUTORIZADO' && resultado != 'RECHAZADO') {
      throw const FormatException('El resultado debe ser AUTORIZADO o RECHAZADO.');
    }

    final fecha = DateTime.tryParse(fechaHora);
    if (fecha == null) {
      throw const FormatException('La fechaHora de un registro no es válida.');
    }
    return RegistroAcceso(usuario: usuario, fechaHora: fecha, resultado: resultado);
  }
}
