import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Widgets/PracticeQuiz/quiz_card.dart';

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
            child: Text('Quiz', style: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Text(
              'Which quiz do you want to play?',
              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  QuizCard(
                    title: 'Maths',
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == 'Maths',
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz == 'Maths' ? null : 'Maths';
                      });
                    },
                  ),
                  QuizCard(
                    title: 'Science',
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == 'Science',
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz == 'Science' ? null : 'Science';
                      });
                    },
                  ),
                  QuizCard(
                    title: 'Alphabet Quiz',
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == 'Alphabet Quiz',
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz == 'Alphabet Quiz' ? null : 'Alphabet Quiz';
                      });
                    },
                  ),
                  QuizCard(
                    title: 'Match Word',
                    imagePath: 'assets/Home_Screen/study.png',
                    isSelected: _selectedQuiz == 'Match Word',
                    onTap: () {
                      setState(() {
                        _selectedQuiz = _selectedQuiz == 'Match Word' ? null : 'Match Word';
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_selectedQuiz != null)
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Continue',
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
