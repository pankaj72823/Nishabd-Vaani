import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/gujarati_alphabet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/gujarati_alphabet.dart';
class CorrectGujarati extends ConsumerWidget {
  final String selectedOption;
  final String answer;

  CorrectGujarati({required this.selectedOption, required this.answer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Correct',
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 20, 217, 105),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/Learning/correct.png'),
              const SizedBox(height: 20),
              Text(
                'Hurray! You got it correct',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async{
                    await ref.read(GujaratialphabetProvider.notifier).fetchNextAlphabet();
                    Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GujaratiAlphabet(),
                      ),
                    );
                  });
                },
                child: Text('Continue',  style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 20, 217, 105),
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

