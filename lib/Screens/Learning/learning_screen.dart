import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Numbers/maths_option.dart';
import 'package:nishabdvaani/Screens/Learning/letter.dart';
import 'package:nishabdvaani/Widgets/LearningWidgets/learning_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  String? _selectedModule;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.learning_corner, style: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold))),
          backgroundColor: Colors.lightBlue[100],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16,),
              Text(
                AppLocalizations.of(context)!.what_you_want_to_learn,
                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  children: [
                    LearningCard(
                      title: AppLocalizations.of(context)!.alphabets,
                      imagePath: 'assets/Tables/alphabets.jpg',
                      isSelected: _selectedModule ==AppLocalizations.of(context)!.alphabets,
                      onTap: () {
                        setState(() {
                          _selectedModule  = _selectedModule  == AppLocalizations.of(context)!.alphabets ? null : AppLocalizations.of(context)!.alphabets;
                        });
                      },
                    ),
                    LearningCard(
                      title: AppLocalizations.of(context)!.maths,
                      imagePath: 'assets/Tables/number.jpg',
                      isSelected: _selectedModule  == AppLocalizations.of(context)!.maths,
                      onTap: () {
                        setState(() {
                          _selectedModule  = _selectedModule  == AppLocalizations.of(context)!.maths ? null : AppLocalizations.of(context)!.maths;
                        });
                      },
                    ),
                    LearningCard(
                      title: AppLocalizations.of(context)!.science,
                      imagePath: 'assets/Tables/science.jpg',
                      isSelected: _selectedModule  ==  AppLocalizations.of(context)!.science,
                      onTap: () {
                        setState(() {
                          _selectedModule  = _selectedModule ==  AppLocalizations.of(context)!.science ? null :  AppLocalizations.of(context)!.science;
                        });
                      },
                    ),
                    LearningCard(
                      title: AppLocalizations.of(context)!.vocabulary,
                      imagePath: 'assets/Tables/vocabulary.png',
                      isSelected: _selectedModule  ==  AppLocalizations.of(context)!.vocabulary,
                      onTap: () {
                        setState(() {
                          _selectedModule  = _selectedModule  == AppLocalizations.of(context)!.vocabulary ? null : AppLocalizations.of(context)!.vocabulary;
                        });
                      },
                    ),
                  ],
              ),
               const SizedBox(height:32,),
               ElevatedButton(
                    onPressed: _selectedModule != null
                      ? () {
                         HapticFeedback.vibrate();
                      if(_selectedModule== AppLocalizations.of(context)!.alphabets){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (ctx) => const Letter(),
                        ),
                        );
                      }
                      if(_selectedModule== AppLocalizations.of(context)!.maths){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (ctx) => const MathsOption(),
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
            ],
          ),
        ),
      ),
    );
  }
}