
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GujaratialphabetProvider = StateNotifierProvider<GujaratiAlphabetNotifier, GujaratiAlphabetState>((ref) {
  return GujaratiAlphabetNotifier();
});

class GujaratiAlphabetState {
  final String alphabet;
  final String signImage;
  final String objectImage;
  final String flag;
  final String question;
  final List<String> options;
  final String answer;

  GujaratiAlphabetState({
    required this.alphabet,
    required this.signImage,
    required this.objectImage,
    required this.flag,
    this.question = '',
    this.options = const [],
    this.answer = '',
  });

  factory GujaratiAlphabetState.initial() {
    return GujaratiAlphabetState(
      alphabet: '',
      signImage: '',
      objectImage: '',
      flag: 'Learn',
    );
  }
}

class GujaratiAlphabetNotifier extends StateNotifier<GujaratiAlphabetState> {
  GujaratiAlphabetNotifier() : super(GujaratiAlphabetState.initial());

  void setAlphabetData({
    required String alphabet,
    required String signImage,
    required String objectImage,
    required String flag,
  }) {
    state = GujaratiAlphabetState(
      alphabet: alphabet,
      signImage: signImage,
      objectImage: objectImage,
      flag: flag,
    );
  }

  Future<void> fetchNextAlphabet() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.173.164:5000/learning/alphabetGuj/next'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('flag')) {
          if (data['flag'] == 'Learn') {
            state = GujaratiAlphabetState(
              alphabet: data['alphabet'],
              signImage: data['signImage'],
              objectImage: data['objectImage'],
              flag: data['flag'],
            );
          } else if (data['flag'] == 'quiz') {
            state = GujaratiAlphabetState(
              alphabet: '',
              signImage: '',
              objectImage: '',
              flag: data['flag'],
              question: data['question'],
              options: (data['options'][0] as Map<String, dynamic>).values
                  .toList().cast<String>(),
              answer: data['answer'],
            );
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load alphabet: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchPreviousAlphabet() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.173.164:5000/learning/alphabetGuj/prev'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('alphabet')) {
          state = GujaratiAlphabetState(
            alphabet: data['alphabet'],
            signImage: data['signImage'],
            objectImage: data['objectImage'],
            flag: data['flag'],
          );
        } else {

          throw Exception('Invalid response format');
        }
      } else {

        throw Exception('Failed to load alphabet: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}