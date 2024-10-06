import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LetterCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const LetterCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.black.withOpacity(0.9),
      highlightColor: Colors.orangeAccent.withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 200,
        width: 400,
        decoration: BoxDecoration(
          color: isSelected ?  Colors.orange[300] : Colors.orange[100],
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
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
