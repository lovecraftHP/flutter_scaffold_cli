import 'dart:io';

import 'package:args/command_runner.dart';

import '../templates/project_templates.dart';
import '../templates/screen_templates.dart';
import '../utils/case_utils.dart';
import '../utils/file_utils.dart';

class CreateCommand extends Command<void> {
  CreateCommand() {
    argParser
      ..addOption('org', help: 'Reverse-domain org, passed to `flutter create` (e.g. com.mycompany).', defaultsTo: 'com.example')
      ..addOption('primary', help: 'Primary theme color, 6-digit hex, no #.', defaultsTo: '2563EB')
      ..addOption('secondary', help: 'Secondary theme color, 6-digit hex, no #.', defaultsTo: 'F59E0B')
      ..addFlag('skip-flutter-create', help: 'Skip running `flutter create` (use if you already have a project dir).', negatable: false)
      ..addFlag('force', help: 'Overwrite files that already exist.', negatable: false);
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project pre-loaded with login/register/forgot-password/home/details/profile,'
      ' Riverpod, AutoRoute, Slang, Retrofit, Skeletonizer and the Clean Architecture folder layout.';

  @override
  String get invocation => 'fsc create <project_name>';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      usageException('Missing project name. Example: fsc create my_app');
    }
    final projectName = toSnakeCase(rest.first);
    final org = argResults!['org'] as String;
    final primary = (argResults!['primary'] as String).replaceFirst('#', '').toUpperCase();
    final secondary = (argResults!['secondary'] as String).replaceFirst('#', '').toUpperCase();
    final skipFlutterCreate = argResults!['skip-flutter-create'] as bool;
    final force = argResults!['force'] as bool;

    if (!skipFlutterCreate) {
      print('🚀 Running: flutter create --org $org $projectName');
      final result = await Process.run('flutter', ['create', '--org', org, projectName]);
      stdout.write(result.stdout);
      if (result.exitCode != 0) {
        stderr.write(result.stderr);
        print('⚠️  `flutter create` failed or Flutter isn\'t on PATH. Continuing to scaffold files into ./$projectName anyway'
            ' (create the directory yourself first if needed) — pass --skip-flutter-create to silence this.');
      }
    }

    FileUtils.ensureDir(projectName);
    Directory.current = Directory(projectName);

    _writePubspecDeps();
    _writeAnalysisOptions(force);
    _writeCoreFiles(force, primary, secondary);
    _writeAuthFeature(force);
    _writeSimpleFeature('home', force);
    _writeSimpleFeature('details', force);
    _writeSimpleFeature('profile', force);
    _writeI18n(force);
    _writeReadmeAndGitignore(force);

    print('\n🎉 Done! cd $projectName && flutter pub get && dart run build_runner build --delete-conflicting-outputs');
  }

  void _writePubspecDeps() {
    FileUtils.mergePubspecDependencies(
      'pubspec.yaml',
      deps: ProjectTemplates.dependencies,
      devDeps: ProjectTemplates.devDependencies,
    );
  }

  void _writeAnalysisOptions(bool force) {
    FileUtils.writeFile('analysis_options.yaml', ProjectTemplates.analysisOptions, force: force);
  }

  void _writeCoreFiles(bool force, String primary, String secondary) {
    FileUtils.writeFile('lib/main.dart', ProjectTemplates.main, force: force);
    FileUtils.writeFile('lib/src/core/router/app_router.dart', ProjectTemplates.appRouter, force: force);
    FileUtils.writeFile(
      'lib/src/core/theme/app_theme.dart',
      ProjectTemplates.theme(primaryHex: primary, secondaryHex: secondary),
      force: force,
    );
    FileUtils.writeFile('slang.yaml', ProjectTemplates.slangConfig, force: force);
    // Empty dirs so `strings.g.dart` (build_runner output) has somewhere to land.
    FileUtils.ensureDir('lib/src/core/i18n');
  }

  void _writeAuthFeature(bool force) {
    const base = 'lib/src/features/auth';
    FileUtils.writeFile('$base/presentation/screens/login_screen.dart', ScreenTemplates.login, force: force);
    FileUtils.writeFile('$base/presentation/screens/register_screen.dart', ScreenTemplates.register, force: force);
    FileUtils.writeFile('$base/presentation/screens/forgot_password_screen.dart', ScreenTemplates.forgotPassword, force: force);
    FileUtils.writeFile('$base/presentation/controllers/auth_state.dart', ProjectTemplates.authState, force: force);
    FileUtils.writeFile('$base/presentation/controllers/auth_controller.dart', ProjectTemplates.authController, force: force);
    FileUtils.ensureDir('$base/presentation/widgets');
    FileUtils.ensureDir('$base/domain/entities');
    FileUtils.ensureDir('$base/data/models');
    FileUtils.ensureDir('$base/data/repositories');
  }

  /// home / details / profile are structurally identical: one screen + one
  /// controller/state pair, following the same folders as everything else.
  void _writeSimpleFeature(String featureLower, bool force) {
    final featurePascal = toPascalCase(featureLower);
    final base = 'lib/src/features/$featureLower';

    final screen = switch (featureLower) {
      'home' => ScreenTemplates.home,
      'details' => ScreenTemplates.details,
      'profile' => ScreenTemplates.profile,
      _ => throw ArgumentError('Unknown built-in feature: $featureLower'),
    };

    FileUtils.writeFile('$base/presentation/screens/${featureLower}_screen.dart', screen, force: force);
    FileUtils.writeFile(
      '$base/presentation/controllers/${featureLower}_state.dart',
      ProjectTemplates.featureState(featureLower, featurePascal),
      force: force,
    );
    FileUtils.writeFile(
      '$base/presentation/controllers/${featureLower}_controller.dart',
      ProjectTemplates.featureController(featureLower, featurePascal),
      force: force,
    );
    FileUtils.ensureDir('$base/presentation/widgets');
    FileUtils.ensureDir('$base/domain/entities');
    FileUtils.ensureDir('$base/data/models');
    FileUtils.ensureDir('$base/data/repositories');
  }

  void _writeI18n(bool force) {
    FileUtils.writeFile('assets/i18n/en.i18n.json', ProjectTemplates.i18nEn, force: force);
    FileUtils.writeFile('assets/i18n/es.i18n.json', ProjectTemplates.i18nEs, force: force);
  }

  void _writeReadmeAndGitignore(bool force) {
    FileUtils.writeFile('NEXT_STEPS.md', ProjectTemplates.projectReadme, force: force);
    final gitignore = File('.gitignore');
    if (gitignore.existsSync()) {
      gitignore.writeAsStringSync(ProjectTemplates.gitignoreExtra, mode: FileMode.append);
      print('✅ Updated: .gitignore');
    } else {
      FileUtils.writeFile('.gitignore', ProjectTemplates.gitignoreExtra, force: force);
    }
  }
}
