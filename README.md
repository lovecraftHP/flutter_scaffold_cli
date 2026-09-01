# fsc — Flutter Scaffold CLI

Herramienta de línea de comandos (escrita en Dart) para dejar de crear las
mismas pantallas y el mismo boilerplate cada vez que arrancas un proyecto
Flutter.

## Qué resuelve

- `fsc create <nombre>` genera un proyecto Flutter nuevo con:
  - Pantallas ya hechas: **login, registro, olvidé password, home, details,
    profile** (con formularios, validaciones básicas, loading state y
    navegación entre ellas).
  - Arquitectura fija: `lib/src/features/<feature>/{presentation,domain,data}`
    (sin carpeta `usecases`, tal como la usas), con `presentation/controllers`,
    `presentation/screens`, `presentation/widgets`, `domain/entities`,
    `data/repositories`, `data/models`.
  - **Riverpod** (codegen, `@riverpod`) ya wireado en `main.dart` con
    `ProviderScope`.
  - **AutoRoute** con `app_router.dart` base + comentarios explicando cuándo
    usar rutas normales vs. anidadas (ej. `chats` → `chats/:id`).
  - **Skeletonizer** ya usado en la pantalla Home como ejemplo.
  - **Slang** con `assets/i18n/en.i18n.json` y `es.i18n.json` de ejemplo,
    usados por todas las pantallas via `t.xxx`.
  - **Retrofit** y **Dio** agregados como dependencias, listos para tu primer
    API client.
  - Tema (`app_theme.dart`) generado a partir de un color primario/secundario
    que le pases.

- `fsc generate repository <Nombre> --feature <feature>` crea el repository +
  su provider de Riverpod.
- `fsc generate controller <Nombre> --feature <feature> [--repository <Nombre>]`
  crea `<nombre>_controller.dart` + `<nombre>_state.dart`, siguiendo tu
  patrón exacto (`class XController extends _$XController`).
- `fsc generate feature <Nombre>` hace las dos cosas de arriba + una pantalla
  stub + las carpetas vacías (`widgets`, `entities`, `models`), todo en un
  solo comando.
- `fsc theme --primary <hex> --secondary <hex>` regenera el tema con nuevos
  colores en segundos — pensado para cuando cambias de proyecto/marca.

## Instalación local (para probarlo)

```bash
cd flutter_scaffold_cli
dart pub get
dart pub global activate --source path .
```

Esto deja el comando `fsc` disponible globalmente (asegúrate de que
`~/.pub-cache/bin` esté en tu PATH). Mientras iteras, también puedes correrlo
directo sin activarlo:

```bash
dart run bin/fsc.dart create mi_app
```

## Uso

```bash
# Proyecto nuevo, con org y colores de marca
fsc create mi_app --org com.miempresa --primary 2563EB --secondary F59E0B

cd mi_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

```bash
# Generar un repository + controller para un feature "user"
fsc generate repository User --feature user
fsc generate controller User --feature user --repository User

# o todo junto, con pantalla stub incluida:
fsc generate feature User

# cambiar el tema de un proyecto existente
fsc theme --primary 7C3AED --secondary 10B981
```

Todos los comandos de `generate` y `theme` deben correrse **desde la raíz de
un proyecto Flutter** (donde está `pubspec.yaml`), igual que `flutter pub get`.

## Notas importantes

- **No pude ejecutar `dart pub get` ni compilar el proyecto en este entorno**
  (no tengo acceso a pub.dev ni a un SDK de Dart instalado aquí), así que
  antes de confiar 100% en él, corre `dart pub get` y prueba
  `fsc create test_app` en tu máquina. Revisé a mano cada plantilla para que
  el Dart generado sea válido, pero es tu primera pasada de QA.
- Las versiones de los paquetes en `project_templates.dart` (Riverpod,
  AutoRoute, Retrofit, Slang, Freezed, etc.) están fijadas a versiones
  razonablemente recientes al momento de escribir esto — probablemente
  quieras correr `flutter pub upgrade --major-versions` la primera vez o
  ajustar los números tú mismo.
- Todas las pantallas generadas asumen que existe un `AuthController` /
  `HomeController` / etc. — los métodos reales (`login()`, `register()`...)
  quedan como `// TODO` porque dependen de tu backend.

## Ideas para siguientes iteraciones

Cosas que noté mientras lo armaba y que podrían valer la pena agregar
después (dime cuáles te interesan y seguimos):

1. **`fsc generate screen <Nombre> --feature <feature>`** — un stub de
   pantalla suelto, para cuando quieres una pantalla nueva sin repository ni
   controller (ej. una pantalla estática de "Términos y condiciones").
2. **Auto-registro de rutas**: que `fsc generate feature` inserte
   automáticamente la línea `AutoRoute(page: XRoute.page, ...)` en
   `app_router.dart` en vez de solo recordártelo — es lo único que hoy sigue
   siendo manual.
3. **`fsc generate model <Nombre> --feature <feature>`** — genera un modelo
   con `json_serializable`/`freezed` en `data/models`.
4. **`fsc generate api <Nombre> --feature <feature>`** — cliente Retrofit
   (`@RestApi()`) básico en `data/`, para no escribirlo a mano cada vez.
5. **Perfiles de tema guardados** (`fsc theme save <nombre>` /
   `fsc theme use <nombre>`) si terminas reusando la misma paleta en varios
   proyectos tipo "cliente X siempre usa estos colores".
6. **Plantillas configurables**: un `fsc.yaml` en la raíz del proyecto donde
   puedas decir "no quiero forgot-password" o "quiero onboarding también",
   en vez de que las 6 pantallas sean fijas en el código de la CLI.
7. **Widget de "empty state" / "error state"** reutilizable, ya que
   Skeletonizer cubre el loading pero normalmente también repites el patrón
   de "no hay datos" / "algo salió mal, reintentar".
8. **Tests**: golden/widget test stub por pantalla generada, si eso es algo
   que sueles escribir.

Lo que **no** metería (al menos no todavía): soporte para otros manejadores
de estado (Bloc, GetX) o para Navigator 2.0 sin AutoRoute — agregaría mucha
complejidad para casos que dijiste que no usas.
