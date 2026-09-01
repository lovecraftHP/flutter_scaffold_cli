import 'package:args/command_runner.dart';

import '../templates/project_templates.dart';
import '../utils/file_utils.dart';

class ThemeCommand extends Command<void> {
  ThemeCommand() {
    argParser
      ..addOption('primary', help: 'Primary color as 6-digit hex, e.g. 2563EB (no #).', mandatory: true)
      ..addOption('secondary', help: 'Secondary color as 6-digit hex, e.g. F59E0B (no #).', mandatory: true)
      ..addFlag('force', help: 'Overwrite the existing theme file.', defaultsTo: true);
  }

  @override
  String get name => 'theme';

  @override
  String get description => 'Regenerate lib/src/core/theme/app_theme.dart with new brand colors.';

  @override
  String get invocation => 'fsc theme --primary <hex> --secondary <hex>';

  static final _hexPattern = RegExp(r'^[0-9A-Fa-f]{6}$');

  @override
  Future<void> run() async {
    final primary = (argResults!['primary'] as String).replaceFirst('#', '');
    final secondary = (argResults!['secondary'] as String).replaceFirst('#', '');
    final force = argResults!['force'] as bool;

    if (!_hexPattern.hasMatch(primary) || !_hexPattern.hasMatch(secondary)) {
      usageException('Colors must be 6-digit hex values, e.g. --primary 2563EB --secondary F59E0B');
    }

    FileUtils.writeFile(
      'lib/src/core/theme/app_theme.dart',
      ProjectTemplates.theme(primaryHex: primary.toUpperCase(), secondaryHex: secondary.toUpperCase()),
      force: force,
    );
  }
}
