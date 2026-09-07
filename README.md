# Control de Acceso Evolutivo v2

Aplicaci\u00f3n Flutter Web para la tarea IF0009. Permite iniciar sesi\u00f3n con
credenciales simuladas, registrar intentos y administrar una bit\u00e1cora JSON.

## Requisitos y ejecuci\u00f3n

- Flutter con Dart 3.13 o superior.
- Un navegador compatible con Flutter Web.

Desde la carpeta del proyecto ejecute:

```bash
flutter pub get
flutter run -d chrome
```

Para comprobar el proyecto:

```bash
flutter analyze
flutter test
flutter build web
```

Las credenciales demostrativas son `admin@frutidemo.com` y `123456`.
No se usa autenticaci\u00f3n real.

## Estructura principal

- `lib/screens/login_page.dart`: formulario de acceso y validaciones.
- `lib/screens/bitacora_page.dart`: consulta, exportaci\u00f3n e importaci\u00f3n.
- `lib/models/registro_acceso.dart`: modelo y conversi\u00f3n JSON.
- `lib/services/preferences_service.dart`: guarda solo el usuario y la opci\u00f3n
  **Recordarme** usando SharedPreferences. Nunca guarda contrase\u00f1as.
- `lib/services/bitacora_service.dart`: conserva la bit\u00e1cora en memoria y la
  convierte hacia/desde JSON. La bit\u00e1cora no se persiste en SharedPreferences.

## Bit\u00e1cora JSON

Cada intento, autorizado o rechazado, contiene usuario, fecha/hora y resultado.
En la pantalla de bit\u00e1cora, **Exportar JSON** descarga
`bitacora_accesos.json`; **Importar JSON** selecciona un arreglo JSON y valida
su estructura antes de reemplazar los registros visibles. Los errores de JSON
o de estructura se muestran en pantalla sin cerrar la aplicaci\u00f3n.

El archivo `bitacora_accesos.json` de la ra\u00edz es un ejemplo seguro que sirve
para demostrar la importaci\u00f3n.
