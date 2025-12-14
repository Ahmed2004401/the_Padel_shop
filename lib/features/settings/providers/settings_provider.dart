import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppTheme { system, light, dark }

class SettingsState {
  final AppTheme theme;
  final String language;
  final bool notificationsEnabled;
  final bool dataSaver;

  const SettingsState({
    this.theme = AppTheme.system,
    this.language = 'en',
    this.notificationsEnabled = true,
    this.dataSaver = false,
  });

  SettingsState copyWith({
    AppTheme? theme,
    String? language,
    bool? notificationsEnabled,
    bool? dataSaver,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dataSaver: dataSaver ?? this.dataSaver,
    );
  }
}

// Simple provider for basic settings
final settingsProvider = Provider<SettingsState>((ref) {
  return const SettingsState();
});
