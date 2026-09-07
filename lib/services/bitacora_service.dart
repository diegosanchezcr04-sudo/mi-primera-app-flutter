import 'dart:convert';

import '../models/registro_acceso.dart';

class BitacoraService {
  static final BitacoraService _instance = BitacoraService._internal();
  factory BitacoraService() => _instance;
  BitacoraService._internal();

  final List<RegistroAcceso> _registros = [];
  List<RegistroAcceso> get registros => List.unmodifiable(_registros);

  void agregar(RegistroAcceso registro) => _registros.add(registro);

  String exportarJson() => const JsonEncoder.withIndent('  ')
      .convert(_registros.map((registro) => registro.toJson()).toList());

  void importarJson(String contenido) {
    late final dynamic decoded;
    try {
      decoded = jsonDecode(contenido);
    } on FormatException {
      throw const FormatException('El archivo no contiene JSON válido.');
    }
    if (decoded is! List) {
      throw const FormatException('El JSON debe contener un arreglo de registros.');
    }

    final registrosImportados = <RegistroAcceso>[];
    for (final item in decoded) {
      if (item is! Map) {
        throw const FormatException('Cada elemento del arreglo debe ser un objeto.');
      }
      registrosImportados.add(
        RegistroAcceso.fromJson(Map<String, dynamic>.from(item)),
      );
    }

    _registros
      ..clear()
      ..addAll(registrosImportados);
  }
}
