import 'dart:io';

class FileUtils {
  /// Writes [content] to [path], creating parent directories as needed.
  /// Skips the write (with a warning) if the file already exists, unless
  /// [force] is true.
  static void writeFile(String path, String content, {bool force = false}) {
    final file = File(path);
    if (file.existsSync() && !force) {
      stdout.writeln('⚠️  Skipped (already exists, use --force to overwrite): $path');
      return;
    }
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
    stdout.writeln('✅ Created: $path');
  }

  static void ensureDir(String path) {
    Directory(path).createSync(recursive: true);
  }

  /// Naive but effective merge: inserts [deps] right after `dependencies:`
  /// and [devDeps] right after `dev_dependencies:` in an existing
  /// pubspec.yaml produced by `flutter create`. Falls back to appending at
  /// the end if the anchors aren't found.
  static void mergePubspecDependencies(
    String pubspecPath, {
    required List<String> deps,
    required List<String> devDeps,
  }) {
    final file = File(pubspecPath);
    if (!file.existsSync()) {
      stdout.writeln('⚠️  Could not find pubspec.yaml at $pubspecPath — skipping dependency merge.');
      return;
    }

    var content = file.readAsStringSync();

    content = _insertAfterAnchor(content, 'dependencies:', deps);
    content = _insertAfterAnchor(content, 'dev_dependencies:', devDeps);

    file.writeAsStringSync(content);
    stdout.writeln('✅ Updated dependencies in: $pubspecPath');
  }

  static String _insertAfterAnchor(String content, String anchor, List<String> lines) {
    if (lines.isEmpty) return content;
    final anchorIndex = content.indexOf('\n$anchor');
    final block = lines.map((l) => '  $l').join('\n');
    if (anchorIndex == -1) {
      // Anchor not found (e.g. no dev_dependencies section yet) — append.
      return '$content\n\n$anchor\n$block\n';
    }
    final insertAt = anchorIndex + '\n$anchor'.length;
    return content.substring(0, insertAt) + '\n$block' + content.substring(insertAt);
  }
}
