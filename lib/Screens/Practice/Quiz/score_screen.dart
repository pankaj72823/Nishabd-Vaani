import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreScreen extends StatelessWidget{
  const ScoreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: 520,
                width: 400,
                child: Stack(
                  children: [
                    Container(
                      height: 340,
                      width: 420,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue,
                              Colors.lightBlueAccent,
                            ]
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white.withOpacity(0.4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text('Alphabet Score',
                                  style: GoogleFonts.openSans(

                                  fontSize: 24,
                                ),
                                ),
                              ),
                              Text('70',
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 280,
                        left: 28,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 200,
                            width: 300,

                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            Text('100%',
                                              style: GoogleFonts.openSans(
                                                fontSize: 24,
                                                color: Colors.blueAccent,
                                            ),
                                            ),
                                          ]
                                        ),
                                        Row(
                                            children: [
                                              Container(
                                                height: 15,
                                                width: 15,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                              Text('10',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 24,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Completion',
                                        style: GoogleFonts.openSans(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text('Total Questions',
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text('05',
                                              style: GoogleFonts.openSans(
                                                fontSize: 24,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ]
                                      ),
                                      Row(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text('02',
                                              style: GoogleFonts.openSans(
                                                fontSize: 24,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Correct',
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text('Wrong',
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(Icons.refresh,color: Colors.white, size: 50,),
                        ),

                      ]
                  ),
                  Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(Icons.visibility_outlined,color: Colors.white, size: 40,),
                        ),
                      ]
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Play again',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                    ),
                  ),
                  Text('Responses',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}