import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/gujarati_alphabet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/gujarati_alphabet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IncorrectGujarati extends ConsumerWidget {
  final String selectedOption;
  final String answer;

  IncorrectGujarati({required this.selectedOption, required this.answer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(48),
        child:  Center(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.wrong,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Image.asset('assets/Learning/incorrect.png', height: 200,), // Add your image here
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.wrong_answer,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                AppLocalizations.of(context)!.correct_answer,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Image.network(answer, width: 300, height: 200,),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                     await ref.read(GujaratialphabetProvider.notifier).fetchNextGujaratiAlphabet();
                    Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GujaratiAlphabet(),
                      ),
                    );
                  });
                    },
                    child: Text(AppLocalizations.of(context)!.next, style: GoogleFonts.openSans(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),),
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
      ),
    );
  }
}