import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Numbers/maths_option.dart';
import 'package:nishabdvaani/Screens/Learning/letter.dart';
import 'package:nishabdvaani/Widgets/LearningWidgets/learning_card.dart';


class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  String? _selectedModule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text('Learning Corner', style: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Text(
              'What you want to Learn ?',
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
                    title: 'Alphabets',
                    imagePath: 'assets/Tables/alphabets.jpg',
                    isSelected: _selectedModule == 'Alphabets',
                    onTap: () {
                      setState(() {
                        _selectedModule  = _selectedModule  == 'Alphabets' ? null : 'Alphabets';
                      });
                    },
                  ),
                  LearningCard(
                    title: 'Maths',
                    imagePath: 'assets/Tables/number.jpg',
                    isSelected: _selectedModule  == 'Maths',
                    onTap: () {
                      setState(() {
                        _selectedModule  = _selectedModule  == 'Maths' ? null : 'Maths';
                      });
                    },
                  ),
                  LearningCard(
                    title: 'Science',
                    imagePath: 'assets/Tables/science.jpg',
                    isSelected: _selectedModule  == 'Science',
                    onTap: () {
                      setState(() {
                        _selectedModule  = _selectedModule == 'Science' ? null : 'Science';
                      });
                    },
                  ),
                  LearningCard(
                    title: 'Vocabulary',
                    imagePath: 'assets/Tables/vocabulary.png',
                    isSelected: _selectedModule  == 'Vocabulary',
                    onTap: () {
                      setState(() {
                        _selectedModule  = _selectedModule  == 'Vocabulary' ? null : 'Vocabulary';
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
                    if(_selectedModule=='Alphabets'){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (ctx) => const Letter(),
                      ),
                      );
                    }
                    if(_selectedModule=='Maths'){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (ctx) => const MathsOption(),
                      ),
                      );
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
    );
  }
}