import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PracticeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const PracticeCard({
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
        height: 200,
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

//
// class PracticeCard extends StatelessWidget {
// final String title;
// final String imagePath;
//
// PracticeCard({
//   required this.title,
//   required this.imagePath,
// });
//
// @override
// Widget build(BuildContext context) {
//   return Container(
//     height: 250,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: Offset(0, 3), // changes position of shadow
//         ),
//       ],
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Row(
//         children: [
//           Image.asset(
//             imagePath,
//             width: 100,
//             height:100,
//           ),
//           SizedBox(width: 20),
//           Text(
//             title,
//             style: GoogleFonts.openSans(
//               fontSize: 28,
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }