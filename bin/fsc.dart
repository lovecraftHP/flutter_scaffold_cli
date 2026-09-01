import 'dart:io';

import 'package:flutter_scaffold_cli/src/cli_runner.dart';

Future<void> main(List<String> arguments) async {
  final runner = buildRunner();
  try {
    await runner.run(arguments);
  } on Object catch (e) {
    stderr.writeln('❌ $e');
    exit(1);
  }
}
