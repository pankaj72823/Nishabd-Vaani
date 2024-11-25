import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/tokenProvider.dart';
import 'package:nishabdvaani/Provider/cookie_provider.dart';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:http/http.dart' as http;


final ProfileProvider = StateNotifierProvider<ProfileNotifier,Profile>((ref){
  return ProfileNotifier(ref);
});


class Profile{
  Profile({
    required this.name,
    required this.email,
    required this.username,
    required this.guardianEmail,
    required this.month,
    required this.activity,
    required this.scienceMarks,
    required this.MathsMarks,
    required this.AlphabetMarks,
    required this.wordMarks
});

  final String name;
  final String email;
  final String username;
  final String guardianEmail;
  final String month;
  final List<int> activity;
  final List<int> scienceMarks;
  final List<int> MathsMarks;
  final List<int> AlphabetMarks;
  final List<int> wordMarks;

  factory Profile.initial() {
    return Profile(
        name: '',
        email: '',
        username: '',
        guardianEmail: '',
        month: '',
        activity: const [],
        scienceMarks: const [],
        MathsMarks: const [],
        AlphabetMarks: const [],
        wordMarks: const []
    );
  }
}


class ProfileNotifier extends StateNotifier<Profile>{
  final Ref ref;
  ProfileNotifier(this.ref) : super(Profile.initial());

  Future<void>profileDetails() async {
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    try{
      final response = await http.get(
        headers: {
          'Authorization': '$token',
          'Content-Type' : 'application/json',
          'Cookie' : '$cookie',
        },
        Uri.parse('http://$ipAddress:5000/students/profile')
      );
      print("Response status code : ${response.statusCode}");
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        print(data);
        print(data['activity']);
        state = Profile(
            name: data['name'],
            email: data['email'],
            username: data['username'],
            guardianEmail: data['gurdianEmail'],
            month: data['month'],
            activity: (data['activityArray'] as List<dynamic>).cast<int>(),
            scienceMarks:(data['quizData']['science'] as List<dynamic>).cast<int>() ,
            MathsMarks: (data['quizData']['maths'] as List<dynamic>).cast<int>(),
            AlphabetMarks: (data['quizData']['alpha'] as List<dynamic>).cast<int>(),
            wordMarks: (data['quizData']['word'] as List<dynamic>).cast<int>(),
        );
      }
      else {
        throw Exception('Failed to load Profile: ${response.statusCode}');
      }
    }
    catch(e){
      print("Error : $e");
    }
  }
}
