import '../utils/case_utils.dart';

class CodeTemplates {
  /// data/repositories/<name>_repository.dart
  static String repository(String rawName) {
    final name = stripSuffix(rawName, 'Repository');
    final pascal = '${name}Repository';
    final camel = toCamelCase(pascal);
    final snake = toSnakeCase(pascal);

    return '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '$snake.g.dart';

/// TODO: inject your data source(s) here (e.g. a Retrofit API client,
/// local storage, etc.) and implement the methods this repository exposes.
class $pascal {
  $pascal(this.ref);

  final Ref ref;

  // Example:
  // Future<UserModel> getById(String id) async {
  //   final api = ref.read(apiClientProvider);
  //   return api.getUser(id);
  // }
}

@riverpod
$pascal $camel(${pascal}Ref ref) {
  return $pascal(ref);
}
''';
  }

  /// presentation/controllers/<name>_state.dart (freezed)
  static String state(String rawName) {
    final name = stripSuffix(rawName, 'State');
    final pascal = '${name}State';
    final snake = toSnakeCase(pascal);

    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '$snake.freezed.dart';

@freezed
class $pascal with _\$$pascal {
  const factory $pascal({
    @Default(false) bool isLoading,
    String? errorMessage,
    // TODO: add your own fields here
  }) = _$pascal;
}
''';
  }

  /// presentation/controllers/<name>_controller.dart (Riverpod codegen)
  static String controller(String rawName, {String? repositoryName}) {
    final name = stripSuffix(rawName, 'Controller');
    final pascal = '${name}Controller';
    final snake = toSnakeCase(pascal);
    final stateName = '${name}State';
    final stateSnake = toSnakeCase(stateName);

    final repoImport = repositoryName == null
        ? ''
        : "import '../../data/repositories/${toSnakeCase(stripSuffix(repositoryName, 'Repository'))}_repository.dart';\n";
    final repoUsageComment = repositoryName == null
        ? '  // TODO: add your methods here.'
        : '''  // Example using ${stripSuffix(repositoryName, 'Repository')}Repository:
  // Future<void> load() async {
  //   state = state.copyWith(isLoading: true, errorMessage: null);
  //   try {
  //     final repo = ref.read(${toCamelCase(stripSuffix(repositoryName, 'Repository'))}RepositoryProvider);
  //     await repo.getById('id');
  //     state = state.copyWith(isLoading: false);
  //   } catch (e) {
  //     state = state.copyWith(isLoading: false, errorMessage: e.toString());
  //   }
  // }''';

    return '''
import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../${stateSnake}.dart';

$repoImport'$stateSnake.dart';

part '$snake.g.dart';

@riverpod
class $pascal extends _\$$pascal {
  @override
  $stateName build() {
    return const $stateName();
  }

$repoUsageComment
}
''';
  }
}
