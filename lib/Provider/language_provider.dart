import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en'); // Default language

  void setLanguage(String newLang) {
    state = newLang;
    print("Language updated to: $state");
  }
  void triggerFunction() {
    print("Function triggered with language: $state");
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
      (ref) => LanguageNotifier(),
);
