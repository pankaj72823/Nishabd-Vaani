import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EnglishAlphabet(),
    );
  }
}

class EnglishAlphabet extends StatefulWidget {
  @override
  _EnglishAlphabetState createState() => _EnglishAlphabetState();
}

class _EnglishAlphabetState extends State<EnglishAlphabet> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> data = [
    {
      'image': 'assets/Learning/alphabet.png', // Update with your image paths
      'symbol': 'assets/Learning/alphabet.png', // Update with your image paths
      'number': '1',
      'word': 'One'
    },
    // Add more entries as needed
  ];

  void _previous() {
    setState(() {
      currentIndex = (currentIndex - 1 + data.length) % data.length;
    });
  }

  void _next() {
    setState(() {
      currentIndex = (currentIndex + 1) % data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = data[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Numbers',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.purple[300],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    currentItem['image'],
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 50,),
                    onPressed: _previous,
                    color: Colors.black,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 50,),
                    onPressed: _next,
                    color: Colors.black,
                  ),

                ],
              ),
              Image.asset(
                currentItem['symbol'],
                width: 50,
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentItem['number'],
                      style: GoogleFonts.openSans(fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      currentItem['word'],
                      style: GoogleFonts.openSans(fontSize: 24, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
