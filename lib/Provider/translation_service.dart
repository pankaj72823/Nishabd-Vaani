import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translate(String text, String targetLanguage) async {
    try {
      var translation = await _translator.translate(text, to: targetLanguage);
      return translation.text;
    } catch (e) {
      print("Error translating text: $e");
      return text;  // Fallback to original text in case of error
    }
  }
}
