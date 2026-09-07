import 'package:flutter/material.dart';
import '../models/registro_acceso.dart';
import '../services/bitacora_service.dart';
import '../services/preferences_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _recordarme = false;
  bool _ocultarPassword = true;
  final _bitacoraService = BitacoraService();
  final _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _cargarUsuarioRecordado();
  }

  Future<void> _cargarUsuarioRecordado() async {
    final usuario = await _preferencesService.obtenerUsuarioRecordado();
    final recordarme = await _preferencesService.estaRecordado();
    if (!mounted) return;
    setState(() {
      _emailController.text = usuario ?? '';
      _recordarme = recordarme;
    });
  }

  String? _validarCorreo(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ingrese el correo';
    if (!value.contains('@') || !value.contains('.')) return 'Correo no válido';
    return null;
  }

  String? _validarPassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese la contraseña';
    return null;
  }

  Future<void> _ingresar() async {
    final esFormValido = _formKey.currentState!.validate();
    final usuario = _emailController.text.trim();
    final password = _passwordController.text;

    // Credenciales simuladas; no se almacena ninguna contraseña.
    final exitoso = esFormValido && usuario == 'admin@frutidemo.com' && password == '123456';

    _bitacoraService.agregar(
      RegistroAcceso(
        usuario: usuario,
        fechaHora: DateTime.now(),
        resultado: exitoso ? 'AUTORIZADO' : 'RECHAZADO',
      ),
    );

    if (_recordarme) {
      await _preferencesService.guardarUsuario(usuario);
    } else {
      await _preferencesService.eliminarUsuarioRecordado();
    }
    if (!mounted) return;

    if (exitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Acceso autorizado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o contraseña incorrectos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'FrutiApp',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validarCorreo,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _ocultarPassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _ocultarPassword
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          icon: Icon(
                            _ocultarPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => _ocultarPassword = !_ocultarPassword);
                          },
                        ),
                      ),
                      validator: _validarPassword,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _recordarme,
                          onChanged: (value) {
                            setState(() => _recordarme = value ?? false);
                          },
                        ),
                        const Text('Recordarme'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _ingresar,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Ingresar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
