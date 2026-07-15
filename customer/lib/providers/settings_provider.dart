import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App preferences shown on the Settings screen. In-memory only (consistent
/// with the rest of this frontend-only prototype's providers) — wire to
/// `shared_preferences`/a backend once one exists.
class AppSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool darkMode;
  final String language;

  const AppSettings({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.darkMode = false,
    this.language = 'English',
  });

  AppSettings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? darkMode,
    String? language,
  }) {
    return AppSettings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setPushNotifications(bool value) => state = state.copyWith(pushNotifications: value);
  void setEmailNotifications(bool value) => state = state.copyWith(emailNotifications: value);
  void setSmsNotifications(bool value) => state = state.copyWith(smsNotifications: value);
  void setDarkMode(bool value) => state = state.copyWith(darkMode: value);
  void setLanguage(String value) => state = state.copyWith(language: value);
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
