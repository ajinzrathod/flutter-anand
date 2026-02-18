import 'package:shared_preferences/shared_preferences.dart';

class TimerSettingsProvider {
  static const String _timerKey = 'quiz_timer_seconds';
  static const int _defaultTimer = 30;
  static const String _correctPassword = 'anandmandir';

  static int _currentTimer = _defaultTimer;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTimer = prefs.getInt(_timerKey) ?? _defaultTimer;
  }

  static int getTimerSeconds() => _currentTimer;

  static void setTimerSeconds(int seconds) {
    if (seconds >= 5 && seconds <= 60) {
      _currentTimer = seconds;
      _saveTimer(seconds);
    }
  }

  static Future<void> _saveTimer(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timerKey, seconds);
  }

  static bool validatePassword(String password) {
    return password == _correctPassword;
  }

  static void resetToDefault() {
    _currentTimer = _defaultTimer;
    _saveTimer(_defaultTimer);
  }
}

