import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nishabdvaani/Provider/numbers_provider.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Arithmetic/arithmetic_operations.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Numbers/numbers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../Widgets/LearningWidgets/maths_card.dart';
import '../Tables/tables_screen.dart';


class MathsOption extends ConsumerStatefulWidget {
  const  MathsOption ({super.key});

  @override
  _MathsOptionState createState() => _MathsOptionState();
}

class _MathsOptionState extends ConsumerState<MathsOption > {
  int? selectedCardIndex;

  void fetchFirst() async {
    final response = await http.get(Uri.parse('http://192.168.173.164:5000/learning/Number'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final number = data['number'];
      final signImage = data['signImage'];
      final Basket = data['Basket'];
      // final flag = data['flag'];
      ref.read(NumberProvider.notifier).setNumberData(
        number: number,
        signImage: signImage,
        Basket: Basket,
        // flag: flag,
      );

      // Navigate to the EnglishAlphabet screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const Numbers(),
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
            AppLocalizations.of(context)!.maths,
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
                MathsCard(
                  title: AppLocalizations.of(context)!.numbers,
                  imagePath: "assets/Tables/number.jpg",
                  isSelected: selectedCardIndex == 0,
                  onTap: () => setState(() {
                    if (selectedCardIndex == 0) {
                      selectedCardIndex = null; // Deselect the card if already selected
                    } else {
                      selectedCardIndex = 0; // Select the card
                    }
                  }),
                ),
                const SizedBox(height: 32),
                MathsCard(
                  title: AppLocalizations.of(context)!.tables,
                  imagePath: "assets/Tables/table.png",
                  isSelected: selectedCardIndex == 1,
                  onTap: () => setState(() {
                    if (selectedCardIndex == 1) {
                      selectedCardIndex = null; // Deselect the card if already selected
                    } else {
                      selectedCardIndex = 1; // Select the card
                    }
                  }),
                ),
                const SizedBox(height: 32),
                MathsCard(
                  title: AppLocalizations.of(context)!.arithmetic,
                  imagePath: "assets/Tables/arithmetic.jpg",
                  isSelected: selectedCardIndex == 2,
                  onTap: () => setState(() {
                    if (selectedCardIndex == 2) {
                      selectedCardIndex = null;
                    } else {
                      selectedCardIndex = 2; // Select the card
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
              if (selectedCardIndex == 0) {
                fetchFirst();
              } else if (selectedCardIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const TablesScreen(),
                  ),
                );
              } else if (selectedCardIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const ArithmeticOperations(),
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
