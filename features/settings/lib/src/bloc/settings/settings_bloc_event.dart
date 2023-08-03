part of 'settings_bloc_bloc.dart';

abstract class SettingsEvent {}

class SetThemeEvent extends SettingsEvent {
  final bool isDark;

  SetThemeEvent({required this.isDark});
}

class GetThemeEvent extends SettingsEvent {}

class SetTextScaleEvent extends SettingsEvent {
  final double textScale;

  SetTextScaleEvent({required this.textScale});
}

class GetTextScaleEvent extends SettingsEvent {}

class OpenLinkEvent extends SettingsEvent {
  final Uri link;

  OpenLinkEvent({required this.link});
}

class SignOutEvent extends SettingsEvent {}
