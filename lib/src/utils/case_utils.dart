/// Small, dependency-free case conversion helpers.
/// Accepts input like "user", "user_profile", "UserProfile" or "user-profile"
/// and normalizes it.
List<String> _splitWords(String input) {
  final withSpaces = input
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (m) => '${m[1]} ${m[2]}',
      )
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .trim();
  return withSpaces.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
}

String toPascalCase(String input) {
  return _splitWords(input)
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join();
}

String toCamelCase(String input) {
  final pascal = toPascalCase(input);
  if (pascal.isEmpty) return pascal;
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String toSnakeCase(String input) {
  return _splitWords(input).map((w) => w.toLowerCase()).join('_');
}

String toKebabCase(String input) {
  return _splitWords(input).map((w) => w.toLowerCase()).join('-');
}

/// Strips a trailing "Repository" / "Controller" / "State" suffix so the
/// user can type either `User` or `UserRepository` and get the same result.
String stripSuffix(String input, String suffix) {
  final pascal = toPascalCase(input);
  if (pascal.toLowerCase().endsWith(suffix.toLowerCase())) {
    return pascal.substring(0, pascal.length - suffix.length);
  }
  return pascal;
}
