import 'package:flutter_test/flutter_test.dart';

import 'package:frutiapp_web/models/registro_acceso.dart';
import 'package:frutiapp_web/services/bitacora_service.dart';

void main() {
  test('RegistroAcceso convierte correctamente a JSON', () {
    final registro = RegistroAcceso(
      usuario: 'admin@frutidemo.com',
      fechaHora: DateTime.parse('2026-09-08T09:35:00'),
      resultado: 'AUTORIZADO',
    );

    final restaurado = RegistroAcceso.fromJson(registro.toJson());

    expect(restaurado.usuario, 'admin@frutidemo.com');
    expect(restaurado.resultado, 'AUTORIZADO');
  });

  test('BitacoraService rechaza estructuras JSON inv\u00e1lidas', () {
    expect(
      () => BitacoraService().importarJson('{"usuario":"admin"}'),
      throwsFormatException,
    );
  });
}
