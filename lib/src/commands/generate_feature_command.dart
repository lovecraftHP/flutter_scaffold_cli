import 'package:args/command_runner.dart';

import '../templates/code_templates.dart';
import '../utils/case_utils.dart';
import '../utils/file_utils.dart';

/// Scaffolds a brand new feature folder following the project's Clean
/// Architecture convention (presentation/domain/data, no usecases):
///
///   lib/src/features/<name>/
///     presentation/
///       screens/<name>_screen.dart
///       controllers/<name>_controller.dart, <name>_state.dart
///       widgets/            (empty, for feature-specific widgets)
///     domain/
///       entities/           (empty)
///     data/
///       repositories/<name>_repository.dart
///       models/             (empty)
class GenerateFeatureCommand extends Command<void> {
  GenerateFeatureCommand() {
    argParser.addFlag('force', help: 'Overwrite existing files.', negatable: false);
  }

  @override
  String get name => 'feature';

  @override
  String get description => 'Scaffold a full feature: repository + controller/state + screen stub + folders.';

  @override
  String get invocation => 'fsc generate feature <Name>';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      usageException('Missing feature name. Example: fsc generate feature User');
    }
    final rawName = rest.first;
    final force = argResults!['force'] as bool;

    final pascal = toPascalCase(rawName);
    final snake = toSnakeCase(rawName);
    final base = 'lib/src/features/$snake';

    // Empty scaffold dirs.
    for (final dir in [
      '$base/presentation/widgets',
      '$base/domain/entities',
      '$base/data/models',
    ]) {
      FileUtils.ensureDir(dir);
      print('✅ Created directory: $dir');
    }

    // Repository.
    FileUtils.writeFile(
      '$base/data/repositories/${snake}_repository.dart',
      CodeTemplates.repository('$pascal'),
      force: force,
    );

    // Controller + state.
    FileUtils.writeFile(
      '$base/presentation/controllers/${snake}_state.dart',
      CodeTemplates.state('$pascal'),
      force: force,
    );
    FileUtils.writeFile(
      '$base/presentation/controllers/${snake}_controller.dart',
      CodeTemplates.controller('$pascal', repositoryName: pascal),
      force: force,
    );

    // Minimal screen stub wired to the controller.
    FileUtils.writeFile(
      '$base/presentation/screens/${snake}_screen.dart',
      _screenStub(pascal, snake),
      force: force,
    );

    print('\n📌 Don\'t forget to:');
    print('   1. Add a route for ${pascal}Screen in lib/src/core/router/app_router.dart');
    print('   2. Run: dart run build_runner build --delete-conflicting-outputs');
  }

  String _screenStub(String pascal, String snake) => '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/${snake}_controller.dart';

@RoutePage()
class ${pascal}Screen extends ConsumerWidget {
  const ${pascal}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${toCamelCase(pascal)}ControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('$pascal')),
      body: Center(
        child: state.isLoading ? const CircularProgressIndicator() : const Text('TODO: build $pascal UI'),
      ),
    );
  }
}
''';
}
