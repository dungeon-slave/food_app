import 'package:core/core.dart';
import 'package:core/di/app_di.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/usecase/theme/get_theme_usecase.dart';
import 'package:domain/usecase/theme/set_theme_usecase.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:settings/settings.dart';

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SettingsBloc(
        setThemeUseCase: appLocator<SetThemeUseCase>(),
        getThemeUseCase: appLocator<GetThemeUseCase>(),
      ),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          return MaterialApp.router(
            routerDelegate: appLocator<AppRouter>().delegate(),
            routeInformationParser:
                appLocator<AppRouter>().defaultRouteParser(),
            theme: state.isDark ? AppTheme.dark : AppTheme.light,
          );
        },
      ),
    );
  }
}
