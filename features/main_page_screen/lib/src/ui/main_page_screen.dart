import 'package:core/core.dart';
import 'package:core/di/app_di.dart';
import 'package:core_ui/core_ui.dart' show AppLoadingCircle, SettingsWidget;
import 'package:domain/domain.dart' show CheckUserUseCase;
import 'package:domain/usecase/text_scale/fetch_text_scale_usecase.dart';
import 'package:domain/usecase/theme/fetch_theme_usecase.dart';
import 'package:flutter/material.dart';
import 'package:main_page_screen/src/bloc/main_page_bloc.dart';

@RoutePage()
class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainPageBloc(
        checkUserUseCase: appLocator<CheckUserUseCase>(),
        fetchTextScaleUseCase: appLocator<FetchTextScaleUseCase>(),
        fetchThemeUseCase: appLocator<FetchThemeUseCase>(),
        authService: appLocator<AuthService>(),
      ),
      child: BlocConsumer<MainPageBloc, MainPageState>(
        listener: (BuildContext context, MainPageState state) {
          SettingsWidget.of(context).changeTheme(state.isDark);
          SettingsWidget.of(context).changeTextScale(state.textScale);
        },
        builder: (_, MainPageState state) {
          return state.isChecked
              ? const AutoRouter()
              : const AppLoadingCircle();
        },
      ),
    );
  }
}
