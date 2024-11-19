
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:nishabdvaani/Provider/tokenProvider.dart';

import 'cookie_provider.dart';

final NumberProvider = StateNotifierProvider<NumberNotifier, NumberState>((ref) {
  return NumberNotifier(ref);
});

class NumberState {
  final int number;
  final String signImage;
  final String Basket;


  NumberState({
    required this.number,
    required this.signImage,
    required this.Basket,
    // required this.flag,
    // this.question = '',
    // this.options = const [],
    // this.answer = '',
  });

  factory NumberState.initial() {
    return NumberState(
      number: 0,
      signImage: '',
      Basket: '',
      // flag: 'Learn',
    );
  }
}

class NumberNotifier extends StateNotifier<NumberState> {
  final Ref ref;
  NumberNotifier(this.ref) : super(NumberState.initial());

  void setNumberData({
    required int number,
    required String signImage,
    required String Basket,
    // required String flag,
  }) {
    state = NumberState(
      number: number,
      signImage: signImage,
      Basket: Basket,
      // flag: flag,
    );
  }

  Future<void> fetchNext() async {
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);

    try {
      final response = await http.get(
          headers: {
            'Authorization': '$token',
            'Content-Type' : 'application/json',
            'Cookie' : '$cookie',
          },
          Uri.parse('http://$ipAddress:5000/learning/Number/next'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response contains the expected fields
      
            state = NumberState(
              number: data['number'],
              signImage: data['signImage'],
              Basket: data['Basket']
            );
              // flag: data['flag']
          // throw Exception('Invalid response format');
  
    
      }
       else {
        throw Exception('Failed to load alphabet: ${response.statusCode}');
       }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchPrevious() async  {
    final ipAddress = ref.watch(ipAddressProvider);
    try {
      final response = await http.get(
          Uri.parse('http://$ipAddress:5000/learning/Number/prev'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response contains the expected fields
      
            state = NumberState(
              number: data['number'],
              signImage: data['signImage'],
              Basket: data['Basket']
            );
              // flag: data['flag']
          // throw Exception('Invalid response format');
  
    
      }
       else {
        throw Exception('Failed to load alphabet: ${response.statusCode}');
       }
    } catch (e) {
      print('Error: $e');
    }
  }
}