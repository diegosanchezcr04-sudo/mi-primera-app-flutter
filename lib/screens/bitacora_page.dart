import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../services/access_log_service.dart';

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  final _logService = AccessLogService();

  void _descargarJson(String contenido) {
    final base64 = base64Encode(utf8.encode(contenido));
    web.HTMLAnchorElement()
      ..href = 'data:application/json;base64,$base64'
      ..setAttribute('download', 'bitacora_accesos.json')
      ..click();
  }

  void _exportarBitacora() {
    _descargarJson(_logService.exportJson());
  }

  Future<void> _importarBitacora() async {
    const typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    try {
      final contenido = await file.readAsString();
      _logService.importJson(contenido);
      setState(() {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitácora cargada con éxito')),
      );
    } on FormatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON inválido: ${e.message}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo leer el archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _logService.records;

    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de Accesos')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _exportarBitacora,
                      icon: const Icon(Icons.download),
                      label: const Text('Exportar JSON'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _importarBitacora,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Importar JSON'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: records.isEmpty
                      ? const Center(child: Text('No hay accesos registrados.'))
                      : ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final r = records[index];
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  r.exitoso ? Icons.check_circle : Icons.cancel,
                                  color: r.exitoso ? Colors.green : Colors.red,
                                ),
                                title: Text(
                                  r.usuario.isEmpty ? '(sin usuario)' : r.usuario,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(r.fechaHora.toString()),
                                trailing: Text(
                                  r.exitoso ? 'OK' : 'FALLÓ',
                                  style: TextStyle(
                                    color: r.exitoso ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}