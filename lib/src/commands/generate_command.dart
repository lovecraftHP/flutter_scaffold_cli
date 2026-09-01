import 'package:args/command_runner.dart';

import 'generate_controller_command.dart';
import 'generate_feature_command.dart';
import 'generate_repository_command.dart';

class GenerateCommand extends Command<void> {
  GenerateCommand() {
    addSubcommand(GenerateRepositoryCommand());
    addSubcommand(GenerateControllerCommand());
    addSubcommand(GenerateFeatureCommand());
  }

  @override
  String get name => 'generate';

  @override
  List<String> get aliases => ['g'];

  @override
  String get description => 'Generate repositories, controllers or whole features.';
}
