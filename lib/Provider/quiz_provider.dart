import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/cookie_provider.dart';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:http/http.dart' as http;
import 'package:nishabdvaani/Provider/tokenProvider.dart';

final QuizProvider = StateNotifierProvider<MyStatenotifier,MyState >((ref) {
  return MyStatenotifier(ref);
});




final scoreProvider = StateProvider((ref)=> 0);
final counterProvider = StateProvider((ref)=> 0);


abstract class MyState{}

class QuizState extends MyState{

  QuizState({
  required this.message,
  required this.question,
  required this.options,
  required this.correctAnswer,
    required this.difficulty,
  required this.score
  }
  );
  final String message;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int difficulty;
  final int score;

  factory QuizState.initial() {
    return QuizState(
    message: '',
    question: '',
    options: const [],
    correctAnswer: '',
    score: 0,
    difficulty: 0,
    );
}
}

class MatchState extends MyState{
  MatchState({
    required this.question,
    required this.ColumnA,
    required this.ColumnB,
    required this.correctAnswer,
    required this.score
});
  final String question;
  final List<String> ColumnA;
  final List<String> ColumnB;
  final List<Map<String, dynamic>>correctAnswer;
  final int score;

  factory MatchState.initial() {
    return MatchState(
      question: '',
      ColumnA: const [],
      ColumnB: const [],
      correctAnswer: const[{}],
      score : 0,
    );
  }
}

class MyStatenotifier extends StateNotifier<MyState>{
  final Ref ref;
    MyStatenotifier(this.ref) : super(QuizState.initial());
  
  
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
          'module': 'alpha',
          'number_of_que': 7,
        }),
        Uri.parse('http://$ipAddress:5000/quiz/load-questions')
      );
      final res = response.statusCode;
      print(res);
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        print(data['message']);
        print(data['question']['options'][0]);
        state = QuizState(
          message: data['message'],
          question: data['question']['question'],
          options: (data['question']['options'] as List<dynamic>).cast<String>(),
          correctAnswer: data['question']['correctAnswer'],
          difficulty: data['question']['difficulty'],
          score: data['score'],
        );
      }
      else {
        throw Exception('Failed to load question: ${response.statusCode}');
      }
    }
    catch(e){
      print('Error: $e');
    }
  }
  Future<void>fetchNextQuestion(bool? ans) async{
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    print(cookie);
    if(ans==null) ans = false;
    print(ans.runtimeType);
    print(ans);
    try{
      final response = await http.post(
          headers: {
            'Authorization': '$token',
            'Cookie' : '$cookie',
            // 'Content-Type' : 'application/json',
          },
          body: {
            'correct': '${ans}',
          },
          Uri.parse('http://$ipAddress:5000/quiz/answer-question')
      );
      final res = response.statusCode;
      print(res);
      if(response.statusCode==200){
        final data = json.decode(response.body);
        print(data['message']);
        if(data['question']['difficulty']==3){
          state = MatchState(
              question: data['question']['question'],
              ColumnA: (data['question']['options']['columnA'] as List<dynamic>).cast<String>(),
              ColumnB: (data['question']['options']['columnB'] as List<dynamic>).cast<String>(),
              correctAnswer: (data['question']['correctAnswer'] as List<dynamic>).
              cast<Map<String,dynamic>>(),
            score: data['score'],
          );
        }
        else {
          state = QuizState(
            message: data['message'],
            question: data['question']['question'],
            options: (data['question']['options'] as List<dynamic>).cast<
                String>(),
            correctAnswer: data['question']['correctAnswer'],
            difficulty: data['question']['difficulty'],
            score: data['score'],
          );
        }
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
//
//
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nishabdvaani/Provider/cookie_provider.dart';
// import 'package:nishabdvaani/Provider/ip_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:nishabdvaani/Provider/tokenProvider.dart';
//
// final QuizProvider = StateNotifierProvider<Quiznotifier,QuizState >((ref) {
//   return Quiznotifier(ref);
// });
//
//
// final counterProvider = StateProvider((ref)=> 0);
//
// // abstract class myState{};
// class QuizState{
//
//   QuizState({
//     required this.message,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//     required this.difficulty,
//     required this.score
//   }
//       );
//   final String message;
//   final String question;
//   final List<String> options;
//   final String correctAnswer;
//   final int difficulty;
//   final int score;
//
//   factory QuizState.initial() {
//     return QuizState(
//       message: '',
//       question: '',
//       options: const [],
//       correctAnswer: '',
//       score: 0,
//       difficulty: 0,
//     );
//   }
// }
//
// class MatchState{
//   MatchState({
//     required this.ColumnA,
//     required this.ColumnB,
//   });
//
//   final List<String> ColumnA;
//   final List<String> ColumnB;
//
//   factory MatchState.initial() {
//     return MatchState(
//       ColumnA: const [],
//       ColumnB: const [],
//     );
//   }
// }
//
// class Quiznotifier extends StateNotifier<QuizState>{
//   final Ref ref;
//
//   Quiznotifier(this.ref) : super(QuizState.initial());
//
//
//   Future<void>loadQuiz() async{
//     final ipAddress = ref.watch(ipAddressProvider);
//     final token = ref.watch(tokenProvider);
//     final cookie = ref.watch(cookieProvider);
//     try{
//
//       final response = await http.post(
//
//           headers: {
//             'Authorization': '$token',
//             'Content-Type' : 'application/json',
//             'Cookie' : '$cookie',
//           },
//           body: jsonEncode({
//             'module': 'alpha',
//             'number_of_que': 7,
//           }),
//           Uri.parse('http://$ipAddress:5000/quiz/load-questions')
//       );
//       final res = response.statusCode;
//       print(res);
//       if(response.statusCode==200){
//         final data = jsonDecode(response.body);
//         print(data['message']);
//         print(data['question']['options'][0]);
//         state = QuizState(
//           message: data['message'],
//           question: data['question']['question'],
//           options: (data['question']['options'] as List<dynamic>).cast<String>(),
//           correctAnswer: data['question']['correctAnswer'],
//           difficulty: data['question']['difficulty'],
//           score: data['score'],
//
//         );
//
//       }
//       else {
//         throw Exception('Failed to load question: ${response.statusCode}');
//       }
//     }
//     catch(e){
//       print('Error: $e');
//     }
//   }
//
//   Future<void>fetchNextQuestion(bool? ans) async{
//     final ipAddress = ref.watch(ipAddressProvider);
//     final token = ref.watch(tokenProvider);
//     final cookie = ref.watch(cookieProvider);
//     print(cookie);
//     if(ans==null) ans = false;
//     String answer = ans.toString();
//     print(answer.runtimeType);
//     try{
//
//       final response = await http.post(
//           headers: {
//             'Authorization': '$token',
//             'Cookie' : '$cookie',
//             // 'Content-Type' : 'application/json',
//           },
//           body: {
//             'correct': answer
//           },
//           Uri.parse('http://$ipAddress:5000/quiz/answer-question')
//       );
//       final res = response.statusCode;
//       print(res);
//       if(response.statusCode==200){
//         final data = json.decode(response.body);
//         print(data['message']);
//         // if(data['question']['difficulty']){
//         //   state = MatchState(
//         //       ColumnA: data['question']['options'],
//         //       ColumnB:
//         //   )
//         // }
//         state = QuizState(
//           message: data['message'],
//           question: data['question']['question'],
//           options: (data['question']['options'] as List<dynamic>).cast<String>(),
//           correctAnswer: data['question']['correctAnswer'],
//           difficulty: data['question']['difficulty'],
//           score: data['score'],
//
//         );
//       }
//       else {
//         throw Exception('Failed to load alphabet: ${response.statusCode}');
//       }
//     }
//     catch(e){
//       print('Error: $e');
//     }
//   }
//
// }