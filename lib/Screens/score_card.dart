import 'package:flutter/material.dart';

import '../Widgets/Profile/score.dart';

class ScoreCard extends StatefulWidget{
  const ScoreCard({super.key});
  @override
  State<ScoreCard> createState() {
    return _ScoreCardState();
  }

}

class _ScoreCardState extends State<ScoreCard>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Align(
          alignment: Alignment.center,
          child: Text('Scorecard'),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Score(title: 'Maths', imagePath: 'assets/Tables/number.jpg',marks: '70/100',),
            Score(title: 'Alphabets', imagePath: 'assets/Tables/alphabets.jpg',marks: '90/100',),
            Score(title: 'Science', imagePath: 'assets/Tables/science.jpg',marks: '80/100',)
          ],
        ),
    );
  }

}