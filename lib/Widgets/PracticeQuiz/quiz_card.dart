import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class QuizCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizCard({
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
      splashColor: Colors.orangeAccent.withOpacity(0.9),
      highlightColor: Colors.lightBlueAccent.withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue[100] : Colors.white,
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
                height: 100,
              ),
              const SizedBox(width: 32),
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



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// class QuizCard extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const QuizCard({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: isSelected ? Colors.orange[300] : Colors.orange[100],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//           side: BorderSide(
//             color: isSelected ? Colors.orange : Colors.transparent,
//             width: 3.0,
//           ),
//         ),
//         elevation: 4.0,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 imagePath,
//                 width: 60,
//                 height: 60,
//               ),
//               SizedBox(height: 8),
//               Text(
//                 title,
//                 style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
