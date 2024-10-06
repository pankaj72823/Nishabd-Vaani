
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/ip_provider.dart';

final alphabetProvider = StateNotifierProvider<AlphabetNotifier, AlphabetState>((ref) {
  return AlphabetNotifier(ref);
});

class AlphabetState {
  final String alphabet;
  final String signImage;
  final String objectImage;
  final String flag;
  final String question;
  final List<String> options;
  final String answer;

  AlphabetState({
    required this.alphabet,
    required this.signImage,
    required this.objectImage,
    required this.flag,
    this.question = '',
    this.options = const [],
    this.answer = '',
  });

  factory AlphabetState.initial() {
    return AlphabetState(
      alphabet: '',
      signImage: '',
      objectImage: '',
      flag: 'Learn',
    );
  }
}

class AlphabetNotifier extends StateNotifier<AlphabetState> {
  final Ref ref;
  AlphabetNotifier(this.ref) : super(AlphabetState.initial());

  void setAlphabetData({
    required String alphabet,
    required String signImage,
    required String objectImage,
    required String flag,
  }) {
    state = AlphabetState(
      alphabet: alphabet,
      signImage: signImage,
      objectImage: objectImage,
      flag: flag,
    );
  }

  Future<void> fetchNextAlphabet() async {
    final ipAddress = ref.watch(ipAddressProvider);
    try {
      final response = await http.get(
          Uri.parse('http://$ipAddress:5000/learning/alphabetEng/next'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response contains the expected fields
        if (data.containsKey('flag')) {
          if (data['flag'] == 'Learn') {
            state = AlphabetState(
              alphabet: data['alphabet'],
              signImage: data['signImage'],
              objectImage: data['objectImage'],
              flag: data['flag'],
            );
          } else if (data['flag'] == 'quiz') {
            state = AlphabetState(
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
    final ipAddress = ref.watch(ipAddressProvider);
    try {
      final response = await http.get(
          Uri.parse('http://$ipAddress:5000/learning/alphabetEng/prev'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('alphabet')) {
          state = AlphabetState(
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