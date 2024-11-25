import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/EnglishAlphabet/correct_english.dart';
import 'package:nishabdvaani/Screens/Learning/EnglishAlphabet/incorrect_english.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionEnglish extends StatefulWidget {
  final String question;
  final List<String> options;
  final String answer;

  const QuestionEnglish({super.key,
    required this.question,
    required this.options,
    required this.answer,
  });

  @override
  _QuestionEnglishState createState() => _QuestionEnglishState();
}

class _QuestionEnglishState extends State<QuestionEnglish> {
  String? _selectedOption;

  void _checkAnswer(BuildContext context) {
    if (_selectedOption == widget.answer) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorrectEnglish(
            selectedOption: _selectedOption!,
            answer: widget.answer,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IncorrectEnglish(
            selectedOption: _selectedOption!,
            answer: widget.answer,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.quiz_time,
            style: GoogleFonts.openSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Text(
              widget.question,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.quiz_guess_sign,
              style: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            for (var option in widget.options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedOption == option) {
                        _selectedOption = null; // Deselect the option
                      } else {
                        _selectedOption = option; // Select the option
                      }
                    });
                  },
                  child: Image.network(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOption == option
                        ? Colors.purple[300]
                        : Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: _selectedOption == option
                            ? Colors.purple[300]!
                            : Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () {
                      _checkAnswer(context);
                    },
              child: Text(AppLocalizations.of(context)!.answer,style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedOption == null
                    ? Colors.white
                    : Colors.purple[100],
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';

// class QuestionEnglish extends StatelessWidget {
//   final String question;
//   final List<String> options;
//   final String answer;

//   QuestionEnglish({
//     required this.question,
//     required this.options,
//     required this.answer,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Quiz',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.purple,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(question), // Add your image here
//             SizedBox(height: 20),
//             Text(
//               'This is a sign of......🤔',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             for (var option in options)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Add your logic for correct/incorrect answer
//                   },
//                   child: Image.network(option),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
