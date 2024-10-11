import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Arithmetic/addition.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Arithmetic/division.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Arithmetic/multiplication.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Arithmetic/subtraction.dart';
import 'package:nishabdvaani/Widgets/LearningWidgets/arithmetic_card.dart';


class ArithmeticOperations extends StatefulWidget{
  const ArithmeticOperations({super.key});

  @override
  _ArithmeticOperationsState createState()  =>_ArithmeticOperationsState();

}

class _ArithmeticOperationsState extends State<ArithmeticOperations>{
  String? _selectedModule;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text('Arithmetic Operations', style: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Text(
              'What you want to learn?',
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
                ArithmeticCard(
                  title: 'Addition',
                  imagePath: 'assets/Learning/addition.gif',
                  isSelected: _selectedModule == 'Addition',
                  onTap: () {
                    setState(() {
                      _selectedModule  = _selectedModule  == 'Addition' ? null : 'Addition';
                    });
                  },
                ),
                ArithmeticCard(
                  title: 'Subtraction',
                  imagePath: 'assets/Learning/subtraction.gif',
                  isSelected: _selectedModule  == 'Subtraction',
                  onTap: () {
                    setState(() {
                      _selectedModule  = _selectedModule  == 'Subtraction' ? null : 'Subtraction';
                    });
                  },
                ),
                ArithmeticCard(
                  title: 'Multiplication',
                  imagePath: 'assets/Learning/multiplication.gif',
                  isSelected: _selectedModule  == 'Multiplication',
                  onTap: () {
                    setState(() {
                      _selectedModule  = _selectedModule == 'Multiplication' ? null : 'Multiplication';
                    });
                  },
                ),
                ArithmeticCard(
                  title: 'Division',
                  imagePath: 'assets/Learning/division.gif',
                  isSelected: _selectedModule  == 'Division',
                  onTap: () {
                    setState(() {
                      _selectedModule  = _selectedModule  == 'Division' ? null : 'Division';
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
                if(_selectedModule=='Addition'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => Addition(),
                  ),
                  );
                }
                if(_selectedModule=='Subtraction'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => Subtraction(),
                  ),
                  );
                }
                if(_selectedModule=='Multiplication'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => Multiplication(),
                  ),
                  );
                }
                if(_selectedModule=='Division'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => Division(),
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