import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nishabdvaani/Widgets/Conversion/conversion_card.dart';

class Conversion extends StatelessWidget {
  const Conversion({super.key});
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Align(
        alignment: Alignment.center,
        child: Text('Conversion Tool', style: GoogleFonts.openSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,),
            ),
      ),
    backgroundColor: Colors.lightBlue[100],
    ),
    body: const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConversionCard(
            imagePath: 'assets/Conversion/signtotext.gif',
            title: 'Sign to Text',
            description: 'Convert sign language gestures into text.',
          ),
          SizedBox(height: 40.0),
          ConversionCard(
            imagePath: 'assets/Conversion/texttosign.gif',
            title: 'Text to Sign',
            description: 'Convert written text into sign language .',
          ),
        ],
      ),
    ),
  );
}
}


