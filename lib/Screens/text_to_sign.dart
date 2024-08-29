import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextToSign extends StatelessWidget {
  const TextToSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Text to Sign Convertor',style:GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.orange
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('assets/Conversion/texttosign.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Enter Word:',
                style:GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your Word here...',
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Sign Language Output:',
                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Sign will be shown here',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // Action for button press
              //   },
              //   style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              //     backgroundColor: Colors.orange,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         'Learn Signs of Different Words',
              //         style: TextStyle(fontSize: 16),
              //       ),
              //       SizedBox(width: 8),
              //       Icon(Icons.arrow_forward),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
