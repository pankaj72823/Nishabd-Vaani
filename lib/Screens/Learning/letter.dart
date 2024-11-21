import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'dart:convert';
import 'package:nishabdvaani/Screens/Learning/EnglishAlphabet/english_alphabet.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/gujarati_alphabet.dart';
import '../../Provider/alphabet_provider.dart';
import '../../Provider/cookie_provider.dart';
import '../../Provider/gujarati_alphabet_provider.dart';
import '../../Provider/tokenProvider.dart';
import '../../Widgets/LearningWidgets/letter_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Letter extends ConsumerStatefulWidget {
  const Letter({super.key});

  @override
  _LetterState createState() => _LetterState();
}

class _LetterState extends ConsumerState<Letter> {
  int? selectedCardIndex;

  void fetchFirstEnglishAlphabet() async {
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    final response = await http.get(
        headers: {
          'Authorization': '$token',
          'Content-Type' : 'application/json',
          'Cookie' : '$cookie',
        },
        Uri.parse('http://$ipAddress:5000/learning/alphabetEng')
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final alphabet = data['alphabet'];
      final signImage = data['signImage'];
      final objectImage = data['objectImage'];
      final flag = data['flag'];
      ref.read(alphabetProvider.notifier).setAlphabetData(
        alphabet: alphabet,
        signImage: signImage,
        objectImage: objectImage,
        flag: flag,
      );
      HapticFeedback.heavyImpact();
      // Navigate to the EnglishAlphabet screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const EnglishAlphabet(),
        ),
      );
    } else {
      // Handle error
      print('Failed to fetch alphabet data');
    }
  }

  void fetchFirstGujaratiAlphabet() async {
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    final response = await http.get(
        headers: {
          'Authorization': '$token',
          'Content-Type' : 'application/json',
          'Cookie' : '$cookie',
        },
        Uri.parse('http://$ipAddress:5000/learning/alphabetGuj')
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final alphabet = data['alphabet'];
      final signImage = data['signImage'];
      final objectImage = data['objectImage'];
      final flag = data['flag'];
      ref.read(GujaratialphabetProvider.notifier).setGujaratiAlphabetData(
        alphabet: alphabet,
        signImage: signImage,
        objectImage: objectImage,
        flag: flag,
      );
      HapticFeedback.heavyImpact();
      // Navigate to the EnglishAlphabet screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const GujaratiAlphabet(),
        ),
      );
    } else {
      // Handle error
      print('Failed to fetch alphabet data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.alphabets,
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
            AppLocalizations.of(context)!.start_with_basics,
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
                  title: AppLocalizations.of(context)!.english_alphabets,
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
                  title:AppLocalizations.of(context)!.gujarati_alphabets,
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
                fetchFirstEnglishAlphabet();
              } else if (selectedCardIndex == 1) {
                fetchFirstGujaratiAlphabet();
              }
            }
                : null,
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
            child: Text(
              AppLocalizations.of(context)!.continue_text,
              style: GoogleFonts.openSans(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
