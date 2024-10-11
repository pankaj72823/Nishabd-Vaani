import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ArithmeticCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const ArithmeticCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.lightBlue[100] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 3.0,
          ),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 80,
                height: 80,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
