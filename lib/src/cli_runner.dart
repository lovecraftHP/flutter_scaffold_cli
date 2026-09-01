import 'package:args/command_runner.dart';

import 'commands/create_command.dart';
import 'commands/generate_command.dart';
import 'commands/theme_command.dart';

CommandRunner<void> buildRunner() {
  final runner = CommandRunner<void>(
    'fsc',
    'Flutter Scaffold CLI — scaffold new Flutter projects with your standard '
        'screens, Clean Architecture folders, Riverpod, AutoRoute, Slang, '
        'Retrofit and Skeletonizer already wired up, plus generators for '
        'repository/controller pairs.',
  )
    ..addCommand(CreateCommand())
    ..addCommand(GenerateCommand())
    ..addCommand(ThemeCommand());

  return runner;
}
