// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'drawing_board.dart';
// import 'dart:math';
// import 'package:http/http.dart' as http;

// class EnglishBoard extends StatefulWidget {
//   @override
//   _EnglishBoardState createState() => _EnglishBoardState();
// }

// class _EnglishBoardState extends State<EnglishBoard> {
//   String _currentLetter = _getRandomLetter(); // Initialize with a random letter
//   String _feedback = '';
//   String? _predictedLetter;

//   // Method to get a random letter from A to Z
//   static String _getRandomLetter() {
//     final random = Random();
//     final letterIndex = random.nextInt(26); // 26 letters in the alphabet
//     return String.fromCharCode('A'.codeUnitAt(0) + letterIndex);
//   }

//   void _onDrawComplete(List<double> pixels, {int retries = 3, int delay = 2000}) async {
//     try {
//       print('Sending pixel data...');
//       final response = await http.post(
//         Uri.parse('http://192.168.173.164:5000/engBoard'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'pixels': pixels}),
//       );

//       print('Response status code: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _predictedLetter = data['prediction'];
//         });
//       } else if (response.statusCode == 429 && retries > 0) {
//         print('Too many requests. Retrying after delay...');
//         await Future.delayed(Duration(milliseconds: delay));
//         // _onDrawComplete(pixels, retries: retries - 1, delay: delay * 2); // Retry with exponential backoff
//       } else {
//         print('Error');
//         setState(() {
//           _feedback = 'Error: Unable to predict the letter.';
//           _predictedLetter = null;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         print('Failed to fetch the prediction. Please try again');
//         _feedback = 'Failed to fetch the prediction. Please try again.';
//         _predictedLetter = null;
//       });
//     }

//     print('Current letter: $_currentLetter');
//     if (_predictedLetter == _currentLetter) {
//       setState(() {
//         _feedback = 'Correct!';
//       });
//     } else {
//       setState(() {
//         _feedback = 'Incorrect. The correct letter was $_currentLetter';
//       });
//     }

//     setState(() {
//       _currentLetter = _getRandomLetter(); // Get a new random letter for the user to draw
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Draw the Letter'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Expanded widget for the DrawingBoard
//             Expanded(
//               flex: 3, // Adjust flex to control space distribution
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: AspectRatio(
//                   aspectRatio: 1.0, // Keep the drawing area square
//                   child: DrawingBoard(
//                     onDrawComplete: _onDrawComplete,
//                     currentLetter: _currentLetter,
//                   ),
//                 ),
//               ),
//             ),
//             // Feedback text with padding
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 _feedback,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             // Spacer for additional spacing
//             Spacer(flex: 1),
//             // Button or other widgets can be added here
//             SizedBox(height: 20), // Space at the bottom for aesthetics
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'drawing_board.dart';
import 'prediction_service.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
class EnglishBoard extends StatefulWidget {
  @override
  _EnglishBoardState createState() => _EnglishBoardState();
}
class _EnglishBoardState extends State<EnglishBoard> {
  // final PredictionService _predictionService = PredictionService();
  String _currentLetter = _getRandomLetter(); // Initialize with a random letter
  String _feedback = '';
  String?_predictedLetter;

  // Method to get a random letter from A to Z
  static String _getRandomLetter() {
    final random = Random();
    final letterIndex = random.nextInt(26); // 26 letters in the alphabet
    return String.fromCharCode('A'.codeUnitAt(0) + letterIndex);
  }

  void _onDrawComplete(List<double> pixels) async {
    print(pixels);
    // String predictedLetter = await _predictionService.predict(pixels);
    try {
    print('Sending pixel data...');
    final response = await http.post(
      Uri.parse('http://192.168.173.164:5000/engBoard'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pixels': pixels}),
    );
    print('tried');

    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        _predictedLetter = data['prediction'];
      });
    }  // sendPixelData(retries: retries - 1, delay: delay * 2);
     else {
      print('Error');
      setState(() {
        _predictedLetter = null;
      });
    }
  } catch (e) {
    setState(() {
      print('Failed to fetch the prediction. Please try again');
      _predictedLetter = null;
    });
  }
    print('Current letter: $_currentLetter');
    setState(() {
      if (_predictedLetter == _currentLetter) {
        _feedback = 'Correct!';
      } else {
        _feedback = 'Incorrect. The correct letter was $_currentLetter';
      }
      _currentLetter = _getRandomLetter(); // Get a new random letter for the user to draw
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw the Letter'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expanded widget for the DrawingBoard
            Expanded(
              flex: 3, // Adjust flex to control space distribution
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1.0, // Keep the drawing area square
                  child: DrawingBoard(
                    onDrawComplete: _onDrawComplete,
                    currentLetter: _currentLetter,
                  ),
                ),
              ),
            ),
            // Feedback text with padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _feedback,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Spacer for additional spacing
            Spacer(flex: 1),
            // Button or other widgets can be added here
            SizedBox(height: 20), // Space at the bottom for aesthetics
          ],
        ),
      ),
    );
  }
}
// //
//
//
//
// // class _EnglishBoardState extends State<EnglishBoard> {
// //   final PredictionService _predictionService = PredictionService();
// //   String _currentLetter = 'A'; // Start with a letter
// //   String _feedback = '';
//
// //   void _onDrawComplete(List<double> pixels) async {
// //     String predictedLetter = await _predictionService.predict(pixels);
//
// //     setState(() {
// //       if (predictedLetter == _currentLetter) {
// //         _feedback = 'Correct!';
// //       } else {
// //         _feedback = 'Incorrect. The correct letter was $_currentLetter';
// //       }
// //       _currentLetter = _getNextLetter(); // Get the next letter for the user to draw
// //     });
// //   }
//
// //   String _getNextLetter() {
// //     // Logic to select the next letter
// //     // For simplicity, cycling through A to Z
// //     int nextChar = _currentLetter.codeUnitAt(0) + 1;
// //     if (nextChar > 'Z'.codeUnitAt(0)) {
// //       nextChar = 'A'.codeUnitAt(0);
// //     }
// //     return String.fromCharCode(nextChar);
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Draw the Letter'),
// //       ),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // Expanded widget for the DrawingBoard
// //             Expanded(
// //               flex: 3, // Adjust flex to control space distribution
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: AspectRatio(
// //                   aspectRatio: 1.0, // Keep the drawing area square
// //                   child: DrawingBoard(
// //                     onDrawComplete: _onDrawComplete,
// //                     currentLetter: _currentLetter,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             // Feedback text with padding
// //             Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Text(
// //                 _feedback,
// //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ),
// //             // Spacer for additional spacing
// //             Spacer(flex: 1),
// //             // Button or other widgets can be added here
// //             SizedBox(height: 20), // Space at the bottom for aesthetics
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // class EnglishBoard extends StatefulWidget {
// //   @override
// //   _EnglishBoardState createState() => _EnglishBoardState();
// // }
// //
// // class _EnglishBoardState extends State<EnglishBoard> {
// //   final PredictionService _predictionService = PredictionService();
// //   String _currentLetter = 'A'; // Start with a letter
// //   String _feedback = '';
// //
// //   void _onDrawComplete(List<double> pixels) async {
// //     String predictedLetter = await _predictionService.predict(pixels);
// //
// //     setState(() {
// //       if (predictedLetter == _currentLetter) {
// //         _feedback = 'Correct!';
// //       } else {
// //         _feedback = 'Incorrect. The correct letter was $_currentLetter';
// //       }
// //       _currentLetter = _getNextLetter(); // Get the next letter for the user to draw
// //     });
// //   }
// //
// //   String _getNextLetter() {
// //     // Logic to select the next letter
// //     // For simplicity, cycling through A to Z
// //     int nextChar = _currentLetter.codeUnitAt(0) + 1;
// //     if (nextChar > 'Z'.codeUnitAt(0)) {
// //       nextChar = 'A'.codeUnitAt(0);
// //     }
// //     return String.fromCharCode(nextChar);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Draw the Letter'),
// //       ),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           DrawingBoard(onDrawComplete: _onDrawComplete, currentLetter: _currentLetter),
// //           SizedBox(height: 20),
// //           Text(
// //             _feedback,
// //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
