import 'package:args/command_runner.dart';

import '../templates/code_templates.dart';
import '../utils/case_utils.dart';
import '../utils/file_utils.dart';

class GenerateRepositoryCommand extends Command<void> {
  GenerateRepositoryCommand() {
    argParser
      ..addOption('feature', abbr: 'f', help: 'Feature folder this belongs to (e.g. "user").', mandatory: true)
      ..addFlag('force', help: 'Overwrite existing files.', negatable: false);
  }

  @override
  String get name => 'repository';

  @override
  String get description => 'Generate a repository + its Riverpod provider inside a feature\'s data layer.';

  @override
  String get invocation => 'fsc generate repository <Name> --feature <feature>';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      usageException('Missing repository name. Example: fsc generate repository User --feature user');
    }
    final rawName = rest.first;
    final feature = toSnakeCase(argResults!['feature'] as String);
    final force = argResults!['force'] as bool;

    final name = stripSuffix(rawName, 'Repository');
    final snake = toSnakeCase('${name}Repository');

    final path = 'lib/src/features/$feature/data/repositories/$snake.dart';
    FileUtils.writeFile(path, CodeTemplates.repository(rawName), force: force);

    print('\nRemember to run: dart run build_runner build --delete-conflicting-outputs');
  }
}
