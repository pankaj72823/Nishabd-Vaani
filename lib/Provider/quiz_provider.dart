import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/cookie_provider.dart';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:http/http.dart' as http;
import 'package:nishabdvaani/Provider/tokenProvider.dart';

final QuizProvider = StateNotifierProvider<Quiznotifier,QuizState >((ref) {
  return Quiznotifier(ref);
});


final counterProvider = StateProvider((ref)=> 0);
class QuizState{

  QuizState({
  required this.message,
  required this.question,
  required this.options,
  required this.correctAnswer,
  required this.score
  }
  );

  final String message;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int score;

  factory QuizState.initial() {
    return QuizState(
    message: '',
    question: '',
    options: const [],
    correctAnswer: '',
    score: 0,
    );
}
}

class Quiznotifier extends StateNotifier<QuizState>{
  final Ref ref;

  Quiznotifier(this.ref) : super(QuizState.initial());
  
  
  Future<void>loadQuiz() async{
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    try{
      
      final response = await http.post(
        headers: {
          'Authorization': '$token',
          'Content-Type' : 'application/json',
          'Cookie' : '$cookie',
        },
        body: jsonEncode({
          'module': 'maths',
          'number_of_que': 7,
        }),
        Uri.parse('http://$ipAddress:5000/quiz/load-questions')
      );
      final res = response.statusCode;
      print(res);
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        print(data['message']);
        state = QuizState(
          message: data['message'],
          question: data['question']['question'],
          options: (data['question']['options'][0] as Map<String,dynamic>).values
            .toList().cast<String>(),
          correctAnswer: data['question']['correctAnswer'],
          score: data['score'],

        );
      }
      else {
        throw Exception('Failed to load alphabet: ${response.statusCode}');
      }
    }
    catch(e){
      print('Error: $e');
    }
  }

  Future<void>fetchNextQuestion(bool? answer) async{
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    if(answer==null) answer = false;
    try{

      final response = await http.post(
          headers: {
            'Authorization': '$token',
            'Cookie' : '$cookie',
            'Content-Type' : 'application/json',
          },
          body: {
            'correct': answer
          },
          Uri.parse('http://$ipAddress:5000/quiz/answer-question')
      );
      final res = response.statusCode;
      print(res);
      if(response.statusCode==200){
        final data = json.decode(response.body);
        print(data['message']);
        state = QuizState(
          message: data['message'],
          question: data['question']['question'],
          options: (data['question']['options'][0] as Map<String,dynamic>).values
              .toList().cast<String>(),
          correctAnswer: data['question']['correctAnswer'],
          score: data['score'],

        );
      }
      else {
        throw Exception('Failed to load alphabet: ${response.statusCode}');
      }
    }
    catch(e){
      print('Error: $e');
    }
  }
  


}