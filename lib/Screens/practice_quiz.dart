import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Practice/Quiz/start_screen.dart';
import 'package:nishabdvaani/Widgets/PracticeQuiz/quiz_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PracticeQuiz extends StatefulWidget {
  const PracticeQuiz({super.key});

  @override
  _PracticeQuizState createState() => _PracticeQuizState();
}

class _PracticeQuizState extends State<PracticeQuiz> {
  String? _selectedQuiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.quiz_time, style: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Text(
                AppLocalizations.of(context)!.quiz_choice,
              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  QuizCard(
                    title: AppLocalizations.of(context)!.maths,
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == AppLocalizations.of(context)!.maths,
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz == AppLocalizations.of(context)!.maths ? null : AppLocalizations.of(context)!.maths;
                      });
                    },
                  ),
                  QuizCard(
                    title: AppLocalizations.of(context)!.science,
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == AppLocalizations.of(context)!.science,
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz ==AppLocalizations.of(context)!.science ? null : AppLocalizations.of(context)!.science;
                      });
                    },
                  ),
                  QuizCard(
                    title: AppLocalizations.of(context)!.alphabet_practice,
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == AppLocalizations.of(context)!.alphabet_practice,
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz == AppLocalizations.of(context)!.alphabet_practice? null :AppLocalizations.of(context)!.alphabet_practice;
                      });
                    },
                  ),
                  QuizCard(
                    title: AppLocalizations.of(context)!.match_word,
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == AppLocalizations.of(context)!.match_word,
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz ==AppLocalizations.of(context)!.match_word ? null : AppLocalizations.of(context)!.match_word;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_selectedQuiz != null)
              ElevatedButton(
                onPressed: () {
                  if(_selectedQuiz == AppLocalizations.of(context)!.alphabet_practice){
                    Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => const StartScreen(module: 'alpha'),
                  ),
                  );
                  }
                  if(_selectedQuiz == AppLocalizations.of(context)!.maths){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (ctx) => const StartScreen(module: 'maths'),
                    ),
                    );
                  }
                  if(_selectedQuiz == AppLocalizations.of(context)!.science){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (ctx) => const StartScreen(module: 'science'),
                    ),
                    );
                  }


                },
                child: Text(
                  AppLocalizations.of(context)!.continue_text,
                  style: GoogleFonts.openSans(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nishabdvaani/Widgets/PracticeQuiz/quiz_card.dart';
//
// class PracticeQuiz extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Align(
//             alignment: Alignment.center,
//             child: Text('Quiz',  style: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold),)),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16,),
//             Text(
//               'Which quiz you want to play?',
//               style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: [
//                   QuizCard(
//                     title: 'Maths',
//                     imagePath: 'assets/Home_Screen/study.png',
//                   ),
//                   QuizCard(
//                     title: 'Science',
//                     imagePath: 'assets/Home_Screen/study.png',
//                   ),
//                   QuizCard(
//                     title: 'Alphabet Quiz',
//                     imagePath: 'assets/Home_Screen/study.png',
//                   ),
//                   QuizCard(
//                     title: 'Match Word',
//                     imagePath: 'assets/Home_Screen/study.png',
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Continue',style: GoogleFonts.openSans(fontSize: 28,color: Colors.black, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center, ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
