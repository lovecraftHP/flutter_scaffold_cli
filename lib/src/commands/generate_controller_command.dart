import 'package:args/command_runner.dart';

import '../templates/code_templates.dart';
import '../utils/case_utils.dart';
import '../utils/file_utils.dart';

class GenerateControllerCommand extends Command<void> {
  GenerateControllerCommand() {
    argParser
      ..addOption('feature', abbr: 'f', help: 'Feature folder this belongs to (e.g. "user").', mandatory: true)
      ..addOption('repository', abbr: 'r', help: 'Repository name to wire in as a commented usage example (e.g. "User").')
      ..addFlag('force', help: 'Overwrite existing files.', negatable: false);
  }

  @override
  String get name => 'controller';

  @override
  String get description => 'Generate a <Name>Controller + <Name>State pair inside a feature\'s presentation layer.';

  @override
  String get invocation => 'fsc generate controller <Name> --feature <feature> [--repository <Name>]';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      usageException('Missing controller name. Example: fsc generate controller User --feature user');
    }
    final rawName = rest.first;
    final feature = toSnakeCase(argResults!['feature'] as String);
    final repository = argResults!['repository'] as String?;
    final force = argResults!['force'] as bool;

    final name = stripSuffix(rawName, 'Controller');
    final controllerSnake = toSnakeCase('${name}Controller');
    final stateSnake = toSnakeCase('${name}State');

    final dir = 'lib/src/features/$feature/presentation/controllers';
    FileUtils.writeFile('$dir/$stateSnake.dart', CodeTemplates.state(rawName), force: force);
    FileUtils.writeFile(
      '$dir/$controllerSnake.dart',
      CodeTemplates.controller(rawName, repositoryName: repository),
      force: force,
    );

    print('\nRemember to run: dart run build_runner build --delete-conflicting-outputs');
  }
}
