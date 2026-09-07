import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _recordarmeKey = 'recordarUsuario';
  static const _usuarioKey = 'usuarioRecordado';

  Future<String?> obtenerUsuarioRecordado() async {
    final preferences = await SharedPreferences.getInstance();
    final recordarme = preferences.getBool(_recordarmeKey) ?? false;
    return recordarme ? preferences.getString(_usuarioKey) : null;
  }

  Future<bool> estaRecordado() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_recordarmeKey) ?? false;
  }

  Future<void> guardarUsuario(String usuario) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_recordarmeKey, true);
    await preferences.setString(_usuarioKey, usuario);
  }

  Future<void> eliminarUsuarioRecordado() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_recordarmeKey, false);
    await preferences.remove(_usuarioKey);
  }
}
