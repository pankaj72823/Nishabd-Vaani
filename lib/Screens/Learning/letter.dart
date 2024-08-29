import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/english_alphabet.dart';

import '../../Widgets/LearningWidgets/letter_card.dart';


class Letter extends StatefulWidget {
  const Letter({super.key});

  @override
  _LetterState createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  int? selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Alphabets',
            style: GoogleFonts.openSans(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Start with basics",
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
                LetterCard(
                  title: "English Alphabets",
                  imagePath: "assets/Learning/alphabet.png",
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
                LetterCard(
                  title: "Gujarati Alphabets",
                  imagePath: "assets/Learning/gujarati_alphabet.png",
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
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: selectedCardIndex != null
                ? () {
              if (selectedCardIndex == 0) {
                Navigator.push(context, MaterialPageRoute(
                  builder: (ctx) => EnglishAlphabet(),
                ),
                );
              } else if (selectedCardIndex == 1) {
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (ctx) =>
                // ),
                // );
              }
            }
                : null,
            child: Text(
              'Continue',
              style: GoogleFonts.openSans(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.black,
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
