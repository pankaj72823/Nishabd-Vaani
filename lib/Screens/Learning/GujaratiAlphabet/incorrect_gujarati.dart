import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/alphabet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/gujarati_alphabet.dart';

class IncorrectEnglish extends ConsumerWidget {
  final String selectedOption;
  final String answer;

  IncorrectEnglish({required this.selectedOption, required this.answer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wrong',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/Learning/incorrect.jpg'), // Add your image here
            SizedBox(height: 20),
            Text(
              'Oo wrong answer',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Correct answer is:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Image.network(answer, width: 20, height: 20,),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                   await ref.read(alphabetProvider.notifier).fetchNextAlphabet();
                  Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GujaratiAlphabet(),
                    ),
                  );
                });
                  },
                  child: Text('Next', style: GoogleFonts.openSans(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),),
                  style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.red,
                  textStyle: TextStyle(fontSize: 16),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}