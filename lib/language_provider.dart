enum Language { english, gujarati }

class LanguageProvider {
  static Language _selectedLanguage = Language.english;

  static Language get selectedLanguage => _selectedLanguage;

  static void setLanguage(Language language) {
    _selectedLanguage = language;
  }

  static bool isEnglish() => _selectedLanguage == Language.english;

  static bool isGujarati() => _selectedLanguage == Language.gujarati;
}

