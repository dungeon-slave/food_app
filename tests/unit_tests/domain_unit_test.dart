import 'package:domain/repositories/theme_repository.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domain/usecase/theme/fetch_theme_usecase.dart';

void main() {
  final FetchThemeUseCase fetchThemeUseCase =
      FetchThemeUseCase(themeRepository: _ThemeRepositoryTest());

  test(
    'Check FetchThemeUseCase execution',
    () {
      final bool result = fetchThemeUseCase.execute(const NoParams());
      expect(true, result);
    },
  );
}

class _ThemeRepositoryTest implements ThemeRepository {
  @override
  bool fetchAppTheme() => true;
  @override
  Future<void> saveAppTheme(bool isDark) => Future(() => {});
}
