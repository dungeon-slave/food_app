import 'package:bloc/bloc.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecase/theme/set_theme_usecase.dart';
import 'package:domain/usecase/usecase.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<ThemeEvent, SettingsState> {
  final SetThemeUseCase _setThemeUseCase;
  final GetThemeUseCase _getThemeUseCase;

  final SetTextScaleUseCase _setTextScaleUseCase;
  final GetTextScaleUseCase _getTextScaleUseCase;

  SettingsBloc({
    required SetThemeUseCase setThemeUseCase,
    required GetThemeUseCase getThemeUseCase,
    required SetTextScaleUseCase setTextScaleUseCase,
    required GetTextScaleUseCase getTextScaleUseCase,
  })  : _setThemeUseCase = setThemeUseCase,
        _getThemeUseCase = getThemeUseCase,
        _setTextScaleUseCase = setTextScaleUseCase,
        _getTextScaleUseCase = getTextScaleUseCase,
        super(SettingsState(
          isDark: true,
          textScale: AppConstants.textScales[1],
        )) {
    on<SetThemeEvent>(_setTheme);
    on<GetThemeEvent>(_getTheme);
    on<SetTextScaleEvent>(_setTextScale);
    on<GetTextScaleEvent>(_getTextScale);
    add(GetThemeEvent());
    add(GetTextScaleEvent());
  }

  void _setTheme(SetThemeEvent event, Emitter<SettingsState> emit) {
    _setThemeUseCase.execute(event.isDark);
    emit(
      state.copyWith(
        isDark: event.isDark,
      ),
    );
  }

  void _setTextScale(SetTextScaleEvent event, Emitter<SettingsState> emit) {
    _setTextScaleUseCase.execute(event.textScale);
    emit(
      state.copyWith(
        textScale: event.textScale,
      ),
    );
  }

  void _getTheme(GetThemeEvent event, Emitter<SettingsState> emit) {
    emit(
      state.copyWith(
        isDark: _getThemeUseCase.execute(const NoParams()),
      ),
    );
  }

  void _getTextScale(GetTextScaleEvent event, Emitter<SettingsState> emit) {
    emit(
      state.copyWith(
        textScale: _getTextScaleUseCase.execute(
          const NoParams(),
        ),
      ),
    );
  }
}
