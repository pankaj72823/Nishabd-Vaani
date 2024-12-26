import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Practice/writing_pad.dart';
import 'package:nishabdvaani/Screens/practice_quiz.dart';
import 'package:nishabdvaani/Widgets/Practice/practice_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  int? selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.practice,
            style: GoogleFonts.openSans(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.lets_start_practice,
            style: GoogleFonts.openSans(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                PracticeCard(
                  title:AppLocalizations.of(context)!.quiz_time,
                  imagePath: "assets/Practice_Screen/quiz.gif",
                  isSelected: selectedCardIndex == 0,
                  onTap: () => setState(() {
                    if (selectedCardIndex == 0) {
                      selectedCardIndex = null; // Deselect the card if already selected
                    } else {
                      selectedCardIndex = 0; // Select the card
                    }
                  }),
                ),
                const SizedBox(height: 20),
                PracticeCard(
                  title: AppLocalizations.of(context)!.writing_practice,
                  imagePath: "assets/Practice_Screen/test.gif",
                  isSelected: selectedCardIndex == 1,
                  onTap: () => setState(() {
                    if (selectedCardIndex == 1) {
                      selectedCardIndex = null; // Deselect the card if already selected
                    } else {
                      selectedCardIndex = 1; // Select the card
                    }
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: selectedCardIndex != null
                ? () {
                  HapticFeedback.vibrate();
              if (selectedCardIndex == 0) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => const PracticeQuiz(),
                  ),
                  );
              } else if (selectedCardIndex == 1) {
                Navigator.push(context, MaterialPageRoute(
                  builder: (ctx) =>  WritingPad(),
                ),
                );
              }
            }
                : null,
            child: Text(
              AppLocalizations.of(context)!.continue_text,
              style: GoogleFonts.openSans(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              textStyle: const TextStyle(fontSize: 16),
              elevation: 8,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
