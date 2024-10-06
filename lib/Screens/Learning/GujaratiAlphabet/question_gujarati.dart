import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/correct_gujarati.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/incorrect_gujarati.dart';
// import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/correct_gujarati.dart';

class QuestionGujarati extends StatefulWidget {
  final String question;
  final List<String> options;
  final String answer;

  QuestionGujarati({
    required this.question,
    required this.options,
    required this.answer,
  });

  @override
  _QuestionGujaratiState createState() => _QuestionGujaratiState();
}

class _QuestionGujaratiState extends State<QuestionGujarati> {
  String? _selectedOption;

  void _checkAnswer(BuildContext context) {
    if (_selectedOption == widget.answer) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorrectGujarati(
            selectedOption: _selectedOption!,
            answer: widget.answer,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IncorrectGujarati(
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
            'Quiz Time',
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
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Text(
                widget.question,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Guess the Sign of the letter',
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
                    child: Image.network(option, width: 100, height: 100,),
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
                child: Text('Answer',style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
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
      ),
    );
  }
}




