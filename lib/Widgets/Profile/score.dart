import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Score extends StatelessWidget {
  final String title;
  final String imagePath;
  final String marks;
  const Score({
    super.key,
    required this.title,
    required this.imagePath,
    required this.marks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        height: 100,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    marks,
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
